import 'package:wattles/wattles.dart';

/// {@template repository}
/// A repository for performing actions on the database of a given [Struct]'s
/// [Schema].
/// {@endtemplate}
class Repository<T extends Struct> {
  /// {@macro repository}
  Repository({
    required Schema schema,
    required DataSource source,
  })  : assert(schema is T, 'schema must be of type $T'),
        _rootSchema = schema,
        _source = source;

  final Schema _rootSchema;

  final DataSource _source;

  DatabaseDriver get _driver => _source.driver;

  SchemaProperty get _primaryKey => _rootSchema.properties.firstWhere(
        (prop) => prop.isPrimary,
      );

  /// Creates a new instance of the [T] type.
  ///
  /// This does not insert the instance into the database. You can use [save]
  /// for that.
  T create() => _createInstance();

  /// Save or update the given data to the database.
  Future<T> save(T data) async {
    final instance = data as SchemaInstance;
    final primary = instance.get(_primaryKey);

    if (primary == null) {
      await _driver.insert(_rootSchema, instance);
    } else {
      await _driver.update(
        _rootSchema,
        instance,
        query: Query([
          [Where(_primaryKey, Operator.equals, primary.value)]
        ]),
      );
    }

    // Everything is either inserted or updated, so lets save all the values.
    for (final prop in _rootSchema.properties) {
      instance.get(prop)?.persist();
    }

    return data;
  }

  /// Delete the given data from the database.
  Future<void> delete(T data) async {
    final instance = data as SchemaInstance;
    final primary = instance.get(_primaryKey);

    if (primary == null) {
      return;
    }

    await _driver.delete(
      _rootSchema,
      query: Query([
        [Where(_primaryKey, Operator.equals, primary.value)]
      ]),
    );
  }

  /// Create a query builder.
  QueryBuilder<T> query() {
    return QueryBuilder<T>(_rootSchema, (query) async {
      final result = await _driver.query(_rootSchema, query: query);
      return result.map((e) {
        final instance = _rootSchema.instance();
        Schema.setAll(_rootSchema, instance, e);
        return instance as T;
      }).toList();
    });
  }

  /// Get a single instance by a given [key].
  Future<T?> Function(V) getBy<V>(V Function(T) key) {
    final invocation = SchemaInvocation(key, arguments: [_rootSchema as T]);

    return (V value) async {
      final result = await _driver.query(
        _rootSchema,
        query: Query([
          [Where(_rootSchema.getProperty(invocation), Operator.equals, value)]
        ]),
      );

      if (result.isEmpty) {
        return null;
      }
      return _createInstance(result.first);
    };
  }

  T _createInstance([Map<String, dynamic>? data]) {
    final instance = _rootSchema.instance();
    Schema.setAll(_rootSchema, instance, data ?? {});
    return instance as T;
  }
}
