import 'package:wattles/src/schemas/schema_base.dart';
import 'package:wattles/wattles.dart';

/// {@template schema}
/// A schema represents the properties of a [Struct]. It is used to validate
/// the properties of a [SchemaInstance] when it is created or updated.
///
/// Every class that extends this will be considered the root schema of a
/// [Struct].
///
/// It extends [SchemaBase] purely for the purpose of being able to cast to
/// either [SchemaInstance] or [SchemaQueryable].
abstract class Schema extends SchemaBase with SchemaInstance, SchemaQueryable {
  /// {@macro schema}
  Schema(this._create, {required this.table});

  /// Create an instance of the [Schema].
  final Schema Function() _create;

  final String table;

  /// Create a new instance of the [Schema]. Used for storing data locally.
  SchemaInstance instance() => _create()..isInstance = true;

  /// Create a new instance of the [Schema]. Used for querying data.
  SchemaQueryable queryable() => _create()..isQueryable = true;

  /// The properties of the [Schema] that are mapped through [assign].
  final List<SchemaProperty> properties = [];

  /// Assign a given [Struct] property and map its attributes to what it is in
  /// the database.
  void assign<T>(
    T Function() key, {
    required String fromKey,
    bool isPrimary = false,
  }) {
    final invocation = SchemaInvocation(key);

    properties.add(
      SchemaProperty(
        invocation.memberName,
        fromKey: fromKey,
        isPrimary: isPrimary,
        isNullable: '$T'.endsWith('?'),
      ),
    );
  }

  /// Get the [SchemaProperty] for a given [Struct] property.
  SchemaProperty getProperty(SchemaInvocation invocation) {
    return properties.firstWhere(
      (property) => property.propertyName == invocation.memberName,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final schemaInvocation = SchemaInvocation.fromInvocation(invocation);
    if (isInstance) {
      return noSuchInstanceMethod(schemaInvocation);
    }
    if (isQueryable) {
      return noSuchQueryMethod(schemaInvocation);
    }
    throw schemaInvocation;
  }

  @override
  String toString() {
    if (isInstance) {
      return toInstanceString();
    }
    return super.toString();
  }

  /// Validate the [data] and set it to the [instance] based on the
  /// [properties] defined in the [rootSchema].
  static void setAll(
    Schema rootSchema,
    SchemaInstance instance,
    Map<String, dynamic> data,
  ) {
    for (final property in rootSchema.properties) {
      if (data.containsKey(property.fromKey)) {
        instance.set(property, data[property.fromKey]);
      }
    }
  }
}
