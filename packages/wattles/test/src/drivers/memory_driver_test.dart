// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

abstract class _TestStruct extends Struct {
  int? id;

  late String key;
}

class _TestSchema extends Schema implements _TestStruct {
  _TestSchema() : super(_TestSchema.new, table: 'test') {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => key, fromKey: 'key');
  }
}

void main() {
  group('MemoryDriver', () {
    late _TestSchema rootSchema;
    late DatabaseDriver driver;

    setUp(() {
      rootSchema = _TestSchema();
      driver = MemoryDriver();
    });

    group('insert', () {
      test('inserts a record', () async {
        final instance1 = rootSchema.instance();
        (instance1 as _TestStruct).key = 'key';

        final instance2 = rootSchema.instance();
        (instance2 as _TestStruct).key = 'other key';

        await driver.insert(rootSchema, instance1);
        await driver.insert(rootSchema, instance2);

        expect((instance1 as _TestStruct).id, equals(1));
        expect((instance2 as _TestStruct).id, equals(2));
      });
    });

    group('update', () {
      late _TestStruct instance;
      late SchemaProperty primaryKey;

      setUp(() async {
        instance = (rootSchema.instance() as _TestStruct)..key = 'key';
        await driver.insert(
          rootSchema,
          instance as SchemaInstance,
        );

        primaryKey = rootSchema.properties.firstWhere((prop) => prop.isPrimary);
      });

      test('updates a record', () async {
        instance.key = 'new key';

        final result = await driver.update(
          rootSchema,
          instance as SchemaInstance,
          query: Query([
            [Where(primaryKey, Operator.equals, instance.id)]
          ]),
        );

        expect(result, equals(1));
        expect(instance.id, equals(1));
        expect(instance.key, equals('new key'));
      });

      test('updates no records if none are found', () async {
        final result = await driver.update(
          rootSchema,
          instance as SchemaInstance,
          query: Query([
            [Where(primaryKey, Operator.equals, 2)]
          ]),
        );

        expect(result, equals(0));
        expect(instance.id, equals(1));
        expect(instance.key, equals('key'));
      });

      test('updates no records if no changes are found', () async {
        final result = await driver.update(
          rootSchema,
          instance as SchemaInstance,
          query: Query([
            [Where(primaryKey, Operator.equals, instance.id)]
          ]),
        );

        expect(result, equals(0));
        expect(instance.id, equals(1));
        expect(instance.key, equals('key'));
      });
    });

    group('delete', () {
      setUp(() async {
        final first = (rootSchema.instance() as _TestStruct)..key = 'some';
        final second = (rootSchema.instance() as _TestStruct)..key = 'value';
        final third = (rootSchema.instance() as _TestStruct)..key = 'some';

        await driver.insert(rootSchema, first as SchemaInstance);
        await driver.insert(rootSchema, second as SchemaInstance);
        await driver.insert(rootSchema, third as SchemaInstance);
      });

      test('returns all records', () async {
        final result = await driver.query(rootSchema, query: Query(const []));

        expect(result.length, equals(3));
        expect(result[0]['id'], equals(1));
        expect(result[0]['key'], equals('some'));
        expect(result[1]['id'], equals(2));
        expect(result[1]['key'], equals('value'));
        expect(result[2]['id'], equals(3));
        expect(result[2]['key'], equals('some'));
      });

      test('delete a record', () async {
        final result = await driver.delete(
          rootSchema,
          query: Query([
            [Where(rootSchema.properties.last, Operator.equals, 'value')]
          ]),
        );

        expect(result, equals(1));

        expect(
          (await driver.query(rootSchema, query: Query(const []))).length,
          equals(2),
        );
      });

      test('delete multiple records', () async {
        final result = await driver.delete(
          rootSchema,
          query: Query([
            [Where(rootSchema.properties.last, Operator.equals, 'some')]
          ]),
        );

        expect(result, equals(2));

        expect(
          (await driver.query(rootSchema, query: Query(const []))).length,
          equals(1),
        );
      });

      test('delete no records if none are found', () async {
        final result = await driver.delete(
          rootSchema,
          query: Query([
            [Where(rootSchema.properties.last, Operator.equals, 'none')]
          ]),
        );

        expect(result, equals(0));

        expect(
          (await driver.query(rootSchema, query: Query(const []))).length,
          equals(3),
        );
      });
    });

    group('query', () {
      setUp(() async {
        final first = (rootSchema.instance() as _TestStruct)..key = 'some';
        final second = (rootSchema.instance() as _TestStruct)..key = 'value';
        final third = (rootSchema.instance() as _TestStruct)..key = 'some';

        await driver.insert(rootSchema, first as SchemaInstance);
        await driver.insert(rootSchema, second as SchemaInstance);
        await driver.insert(rootSchema, third as SchemaInstance);
      });

      test('returns all records', () async {
        final result = await driver.query(rootSchema, query: Query(const []));

        expect(result.length, equals(3));
        expect(result[0]['id'], equals(1));
        expect(result[0]['key'], equals('some'));
        expect(result[1]['id'], equals(2));
        expect(result[1]['key'], equals('value'));
        expect(result[2]['id'], equals(3));
        expect(result[2]['key'], equals('some'));
      });

      test('returns records that match the query', () async {
        final result = await driver.query(
          rootSchema,
          query: Query([
            [Where(rootSchema.properties.last, Operator.equals, 'some')]
          ]),
        );

        expect(result.length, equals(2));
        expect(result[0]['id'], equals(1));
        expect(result[0]['key'], equals('some'));
        expect(result[1]['id'], equals(3));
        expect(result[1]['key'], equals('some'));
      });

      test('returns records that match the query with a limit', () async {
        final result = await driver.query(
          rootSchema,
          query: Query(
            [
              [Where(rootSchema.properties.last, Operator.equals, 'some')]
            ],
            limit: 1,
          ),
        );

        expect(result.length, equals(1));
        expect(result[0]['id'], equals(1));
        expect(result[0]['key'], equals('some'));
      });
    });
  });
}
