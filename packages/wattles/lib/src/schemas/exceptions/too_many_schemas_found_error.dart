import 'package:wattles/wattles.dart';

/// {@template too_many_schemas_found_error}
/// Thrown when more than one schema is found for a given struct.
/// {@endtemplate}
class TooManySchemasFound<T extends Struct> extends Error {
  @override
  String toString() => 'Too many schemas found for struct $T';
}
