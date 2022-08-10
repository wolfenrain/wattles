import 'dart:io';

import 'package:wattles/wattles.dart';

/// {@template fake_sql_driver}
/// Fake SQL driver that just writes to memory.
/// {@endtemplate}
class FakeSqlDriver extends MemoryDriver {
  @override
  Future<int> insert(
    Schema rootSchema,
    SchemaInstance instance,
  ) async {
    print('Inserting $instance');
    final fields = {
      for (final prop in rootSchema.properties.where(isNotPrimary))
        prop.fromKey: instance.get(prop)!,
    };

    _logSQL(
      '''
INSERT INTO `${rootSchema.table}` (${fields.keys.map((e) => '`$e`').join(', ')})
  VALUES (${fields.values.map((e) => e.toSQL).join(', ')})
''',
    );

    return super.insert(rootSchema, instance);
  }

  @override
  Future<int> update(
    Schema rootSchema,
    SchemaInstance instance, {
    required Query query,
  }) async {
    print('Updating $instance ${query.toReadable}');
    final sqlFields = {
      for (final prop in rootSchema.properties.where(isModified(instance)))
        '`${prop.fromKey}` = ${instance.get(prop)!.toSQL}',
    };

    _logSQL(
      '''
UPDATE `${rootSchema.table}`
  SET ${sqlFields.join(', ')}
  ${query.toSQL}
''',
    );

    return super.update(rootSchema, instance, query: query);
  }

  @override
  Future<int> delete(Schema rootSchema, {required Query query}) async {
    print('Deleting items ${query.toReadable}');
    _logSQL(
      '''
DELETE FROM `${rootSchema.table}`
  WHERE ${query.toSQL}
''',
    );

    return super.delete(rootSchema, query: query);
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    Schema rootSchema, {
    required Query query,
  }) async {
    print('Finding items ${query.toReadable}');
    final select = rootSchema.properties.map((prop) => '`${prop.fromKey}`');

    _logSQL(
      '''
SELECT ${select.join(', ')} 
  FROM `${rootSchema.table}` 
  ${query.toSQL}
''',
    );

    return super.query(rootSchema, query: query);
  }

  /// Check if given property is not a primary key.
  bool isNotPrimary(SchemaProperty prop) => !prop.isPrimary;

  /// Check if given property is modified.
  bool Function(SchemaProperty) isModified(SchemaInstance instance) =>
      (prop) => instance.get(prop)?.isModified ?? false;

  void _logSQL(String sql) {
    stdout.writeln('\x1b[38;5;32m\n$sql\x1b[0m');
  }
}

extension on Query {
  String get toSQL {
    final wheresSql = wheres
        .map((wheres) {
          return wheres
              .map(
                (w) =>
                    '`${w.property.fromKey}` ${w.operator.toSQL} ${_toSQL(w.value)}',
              )
              .join(' AND ');
        })
        .map((e) => '($e)')
        .join(' OR ');
    return [
      if (wheres.isNotEmpty) 'WHERE $wheresSql',
      if (limit != null) 'LIMIT $limit',
    ].join('\n');
  }

  String get toReadable {
    final wheresReadable = wheres.map((wheres) {
      return wheres
          .map(
            (w) =>
                '${w.property.fromKey} ${w.operator.toReadable} ${_toReadable(w.value)}',
          )
          .join(' and ');
    }).join(' or where ');

    return [
      if (wheres.isNotEmpty) 'where either $wheresReadable',
      if (limit != null) 'limited by $limit items',
    ].join('\n');
  }
}

extension on SchemaValue {
  String get toSQL {
    return _toSQL(value);
  }
}

extension on Operator {
  String get toSQL {
    switch (this) {
      case Operator.equals:
        return '=';
    }
  }

  String get toReadable {
    switch (this) {
      case Operator.equals:
        return 'equals';
    }
  }
}

String _toReadable(dynamic value) {
  if (value is String) {
    return "'$value'";
  } else if (value is bool) {
    return value.toString();
  } else {
    return '$value';
  }
}

String _toSQL(dynamic value) {
  if (value is String) {
    return "'$value'";
  } else if (value is bool) {
    return value ? '1' : '0';
  } else {
    return '$value';
  }
}
