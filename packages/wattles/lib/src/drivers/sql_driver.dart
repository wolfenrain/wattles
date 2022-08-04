import 'dart:io';

import 'package:wattles/wattles.dart';

/// {@template sql_driver}
/// Defines how to interact with an SQL-based database.
/// {@endtemplate}
class SqlDriver extends DatabaseDriver {
  final List<Map<String, dynamic>> _data = [];

  @override
  Future<int> insert(
    String table,
    Schema rootSchema,
    SchemaInstance instance,
  ) async {
    final primaryKey = rootSchema.properties.firstWhere(isPrimary);

    final fields = {
      for (final prop in rootSchema.properties.where(isNotPrimary))
        prop.fromKey: instance.get(prop)!,
    };

    _logSQL(
      '''
INSERT INTO `$table` (${fields.keys.map((e) => '`$e`').join(', ')})
  VALUES (${fields.values.map((e) => e.toSQL).join(', ')})
''',
    );

    final map = fields.map((key, value) => MapEntry(key, value.value));
    _data.add(map);

    final id = _data.length;

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
    // TODO(wolfen): should use query.
    final primaryKey = rootSchema.properties.firstWhere(isPrimary);
    final primary = instance.get(primaryKey);
    if (primary == null) {
      throw ArgumentError('primary key is null');
    }

    final fields = {
      for (final prop in rootSchema.properties.where(isModified(instance)))
        '`${prop.fromKey}` = ${instance.get(prop)!.toSQL}',
    };
    if (fields.isEmpty) {
      return 0;
    }

    _logSQL(
      '''
UPDATE `$table`
  SET ${fields.join(', ')}
  WHERE ${primaryKey.fromKey} = ${primary.value}
''',
    );

    _data.firstWhere((e) => e[primaryKey.fromKey] == primary.value).addAll({
      for (final prop in rootSchema.properties.where(isModified(instance)))
        prop.fromKey: instance.get(prop)!.value,
    });

    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table,
    Schema rootSchema, {
    required Query query,
  }) async {
    final select = rootSchema.properties.map((prop) => '`${prop.fromKey}`');
    final wheres = query.wheres
        .map((wheres) {
          return wheres
              .map(
                (w) => '`${w.property.fromKey}` ${w.operator.toSQL} ${w.value}',
              )
              .join(' AND ');
        })
        .map((e) => '($e)')
        .join(' OR ');

    _logSQL(
      '''
SELECT ${select.join(', ')} 
  FROM `$table` 
  WHERE $wheres
''',
    );

    return _data.where((e) {
      return query.wheres.any(
        (wheres) => wheres.every((where) => where.check(e)),
      );
    }).toList();
  }

  @override
  Future<int> delete(String table, {required String where}) {
    // TODO(wolfen): implement delete
    throw UnimplementedError();
  }

  /// Check if given property is a primary key.
  bool isPrimary(SchemaProperty prop) => prop.isPrimary;

  /// Check if given property is not a primary key.
  bool isNotPrimary(SchemaProperty prop) => !prop.isPrimary;

  /// Check if given property is modified.
  bool Function(SchemaProperty) isModified(SchemaInstance instance) =>
      (prop) => instance.get(prop)?.isModified ?? false;

  void _logSQL(String sql) {
    stdout.writeln('\x1b[2;30m\n$sql\x1b[0m');
  }
}

extension on SchemaValue {
  String get toSQL {
    if (value is String) {
      return "'$value'";
    } else if (value is bool) {
      return value as bool ? '1' : '0';
    } else {
      return '$value';
    }
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

extension on Operator {
  String get toSQL {
    switch (this) {
      case Operator.equals:
        return '=';
    }
  }
}
