import 'package:wattles/src/schemas/schema_base.dart';
import 'package:wattles/wattles.dart';

/// {@template schema_queryable}
/// Used in [QueryBuilder] to write queries on a [Struct].
///
/// Front-facing it is a [Struct] while mapping all the query statements
/// internally.
/// {@endtemplate}
mixin SchemaQueryable on SchemaBase {
  /// Indicates if this [SchemaBase] was created as a queryable or not.
  bool isQueryable = false;

  /// Handle the [noSuchMethod] for the queryable schemas.
  dynamic noSuchQueryMethod(SchemaInvocation invocation) {
    throw (this as Schema)
        .getProperty(invocation); // TODO(wolfen): custom exception?
  }
}
