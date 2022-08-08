import 'dart:collection';

import 'package:wattles/wattles.dart';

class DataSource {
  DataSource.initialize({
    required List<Schema> schemas,
    required this.driver,
  }) : _schemas = schemas;

  final DatabaseDriver driver;

  List<Schema> get schemas => UnmodifiableListView(_schemas);
  final List<Schema> _schemas;

  Repository<T> getRepository<T extends Struct>() {
    final schemas = _schemas.whereType<T>();
    if (schemas.isEmpty) {
      throw Exception('No schema found for type $T');
    }
    if (schemas.length > 1) {
      throw Exception('Multiple schemas found for type $T');
    }
    final rootSchema = schemas.first;

    return Repository<T>(
      schema: rootSchema as Schema,
      source: this,
    );
  }
}
