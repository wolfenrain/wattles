import 'package:wattles/wattles.dart';
import 'package:wattles/src/drivers/memory_driver.dart';

/// {@template repository}
///
/// {@endtemplate}
abstract class Repository<T extends Struct> {
  /// {@macro repository}
  Repository({
    required String table,
    required Schema schema,
  })  : assert(schema is T, 'schema must be of type $T'),
        _table = table,
        _rootSchema = schema;

  final String _table;

  final Schema _rootSchema;

  final DatabaseDriver _driver = MemoryDriver();

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
      await _driver.insert(_table, _rootSchema, instance);
    } else {
      await _driver.update(
        _table,
        _rootSchema,
        instance,
        query: const Query([]),
      );
    }

    // Everything is either inserted or updated, so lets save all the values.
    for (final prop in _rootSchema.properties) {
      instance.get(prop)?.persist();
    }

    return data;
  }

  /// Create a query builder.
  QueryBuilder<T> query() {
    return QueryBuilder<T>(_rootSchema, (query) async {
      final result = await _driver.query(_table, _rootSchema, query: query);
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
        _table,
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

extension on SchemaValue {
  String get toSQL {
    if (value is String) {
      return "'$value'";
    } else if (value is bool) {
      return value as bool ? '1' : '0';
    } else {
      return '$value';
    }
  }
}
