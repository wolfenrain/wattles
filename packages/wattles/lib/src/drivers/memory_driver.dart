import 'package:wattles/wattles.dart';

/// {@template sql_driver}
/// Driver for storing data in memory.
/// {@endtemplate}
class MemoryDriver extends DatabaseDriver {
  final Map<String, List<Map<String, dynamic>>> _data = {};

  @override
  Future<int> insert(
    String table,
    Schema rootSchema,
    SchemaInstance instance,
  ) async {
    final collection = _data.putIfAbsent(table, () => []);
    final primaryKey = rootSchema.properties.firstWhere(isPrimary);

    final fields = {
      for (final prop in rootSchema.properties.where(isNotPrimary))
        prop.fromKey: instance.get(prop)!,
    };

    final map = fields.map((key, value) => MapEntry(key, value.value));
    collection.add(map);

    final id = collection.length;

    instance.set(primaryKey, id);
    return map[primaryKey.fromKey] = id;
  }

  @override
  Future<int> update(
    String table,
    Schema rootSchema,
    SchemaInstance instance, {
    required Query query,
  }) async {
    final collection = _data.putIfAbsent(table, () => []);

    final records = collection.where((e) {
      return query.wheres.any(
        (wheres) => wheres.every((where) => where.check(e)),
      );
    }).toList();

    if (records.isEmpty) {
      return 0;
    }

    final fields = {
      for (final prop in rootSchema.properties.where(isModified(instance)))
        prop.fromKey: instance.get(prop)!.value,
    };
    if (fields.isEmpty) {
      return 0;
    }

    for (final record in records) {
      record.addAll(fields);
    }
    return records.length;
  }

  @override
  Future<int> delete(String table, {required Query query}) async {
    final collection = _data.putIfAbsent(table, () => []);

    final records = collection.where((e) {
      return query.wheres.any(
        (wheres) => wheres.every((where) => where.check(e)),
      );
    }).toList();

    if (records.isEmpty) {
      return 0;
    }

    records.forEach(collection.remove);

    return records.length;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table,
    Schema rootSchema, {
    required Query query,
  }) async {
    final collection = _data.putIfAbsent(table, () => []);

    if (query.wheres.isEmpty) {
      return collection;
    }

    return collection.where((e) {
      return query.wheres.any(
        (wheres) => wheres.every((where) => where.check(e)),
      );
    }).toList();
  }

  /// Check if given property is a primary key.
  bool isPrimary(SchemaProperty prop) => prop.isPrimary;

  /// Check if given property is not a primary key.
  bool isNotPrimary(SchemaProperty prop) => !prop.isPrimary;

  /// Check if given property is modified.
  bool Function(SchemaProperty) isModified(SchemaInstance instance) =>
      (prop) => instance.get(prop)?.isModified ?? false;
}

extension on Where {
  bool check(Map<String, dynamic> data) {
    final dataValue = data[property.fromKey];
    switch (operator) {
      case Operator.equals:
        return dataValue == value;
    }
  }
}