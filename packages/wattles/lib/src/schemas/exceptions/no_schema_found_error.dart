import 'package:wattles/wattles.dart';

/// {@template no_schema_found_error}
/// Thrown when no schema is found for a given struct.
/// {@endtemplate}
class NoSchemaFoundError<T extends Struct> extends Error {
  @override
  String toString() => 'No schema found for struct $T';
}
