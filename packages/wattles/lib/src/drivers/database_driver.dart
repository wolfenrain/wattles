import 'package:wattles/wattles.dart';

/// {@template database_driver}
/// Defines how to interact with a database.
/// {@endtemplate}
abstract class DatabaseDriver {
  /// Insert a new row into the database.
  Future<int> insert(
    String table,
    Schema rootSchema,
    SchemaInstance instance,
  );

  /// Update an existing row in the database.
  Future<int> update(
    String table,
    Schema rootSchema,
    SchemaInstance instance, {
    required Query query,
  });

  /// Delete a row from the database.
  Future<int> delete(String table, {required String where});

  /// Query the database for rows.
  Future<List<Map<String, dynamic>>> query(
    String table,
    Schema rootSchema, {
    required Query query,
  });
}
