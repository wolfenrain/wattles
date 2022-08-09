import 'package:wattles/wattles.dart';

/// {@template database_driver}
/// Defines how to interact with a database.
/// {@endtemplate}
abstract class DatabaseDriver {
  /// Insert a new row into the database.
  Future<int> insert(Schema rootSchema, SchemaInstance instance);

  /// Update an existing row in the database.
  Future<int> update(
    Schema rootSchema,
    SchemaInstance instance, {
    required Query query,
  });

  /// Delete a row from the database.
  Future<int> delete(Schema rootSchema, {required Query query});

  /// Query the database for rows.
  Future<List<Map<String, dynamic>>> query(
    Schema rootSchema, {
    required Query query,
  });
}
