import 'dart:collection';

import 'package:wattles/wattles.dart';

/// {@template data_source}
/// The data source is the main entry point for interacting with any database
/// using the Wattle(s) ORM.
/// {@endtemplate}
class DataSource {
  /// {@macro data_source}
  DataSource.initialize({
    required List<Schema> schemas,
    required this.driver,
  }) : _schemas = schemas;

  /// The driver that is used to interact with the database.
  final DatabaseDriver driver;

  /// The schemas that are available in this data source.
  List<Schema> get schemas => UnmodifiableListView(_schemas);
  final List<Schema> _schemas;

  /// Returns a [DataStore] instance for the given [Struct].
  DataStore<T> getStore<T extends Struct>() {
    final schemas = _schemas.whereType<T>();
    if (schemas.isEmpty) {
      throw NoSchemaFoundError<T>();
    }
    if (schemas.length > 1) {
      throw TooManySchemasFoundError();
    }
    final rootSchema = schemas.first;

    return DataStore<T>(
      schema: rootSchema as Schema,
      source: this,
    );
  }
}
