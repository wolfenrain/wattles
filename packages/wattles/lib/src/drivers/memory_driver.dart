import 'package:wattles/wattles.dart';

/// {@template sql_driver}
/// Driver for storing data in memory.
/// {@endtemplate}
class MemoryDriver extends DatabaseDriver {
  final Map<String, List<Map<String, dynamic>>> _data = {};

  @override
  Future<int> insert(
    Schema rootSchema,
    SchemaInstance instance,
  ) async {
    final collection = _data.putIfAbsent(rootSchema.table, () => []);
    // TODO(wolfen): should be handled more properly.
    final primaryKey = rootSchema.properties.firstWhere(_isPrimary);

    final fields = {
      for (final prop in rootSchema.properties.where(_isNotPrimary))
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
    Schema rootSchema,
    SchemaInstance instance, {
    required Query query,
  }) async {
    final collection = _data.putIfAbsent(rootSchema.table, () => []);

    final records = _getRecords(collection, query);
    if (records.isEmpty) {
      return 0;
    }

    final fields = {
      for (final prop in rootSchema.properties.where(_isModified(instance)))
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
  Future<int> delete(Schema rootSchema, {required Query query}) async {
    final collection = _data.putIfAbsent(rootSchema.table, () => []);

    final records = _getRecords(collection, query);
    if (records.isEmpty) {
      return 0;
    }

    records.forEach(collection.remove);

    return records.length;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    Schema rootSchema, {
    required Query query,
  }) async {
    final collection = _data.putIfAbsent(rootSchema.table, () => []);

    if (query.wheres.isEmpty) {
      return collection;
    }

    return _getRecords(collection, query);
  }

  /// Check if given property is a primary key.
  bool _isPrimary(SchemaProperty prop) => prop.isPrimary;

  /// Check if given property is not a primary key.
  bool _isNotPrimary(SchemaProperty prop) => !prop.isPrimary;

  /// Check if given property is modified.
  bool Function(SchemaProperty) _isModified(SchemaInstance instance) =>
      (prop) => instance.get(prop)?.isModified ?? false;

  List<Map<String, dynamic>> _getRecords(
    List<Map<String, dynamic>> collection,
    Query query,
  ) {
    final records = collection.where((e) {
      return query.wheres.any(
        (wheres) => wheres.every((where) => where.check(e)),
      );
    }).toList();

    return records.sublist(0, query.limit ?? records.length);
  }
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
