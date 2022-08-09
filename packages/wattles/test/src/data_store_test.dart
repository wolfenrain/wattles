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
  group('DataStore', () {
    late _TestSchema rootSchema;
    late DataStore<_TestStruct> dataStore;
    late DataSource dataSource;

    setUp(() {
      rootSchema = _TestSchema();
      dataSource = DataSource.initialize(
        schemas: [rootSchema],
        driver: MemoryDriver(),
      );
      dataStore = dataSource.getStore<_TestStruct>();
    });

    test('create', () {
      final instance = dataStore.create()..key = 'test';

      expect(instance.id, isNull);
      expect(instance.key, equals('test'));
    });

    group('save', () {
      test('saves a new record', () async {
        final instance = dataStore.create()..key = 'test';

        await dataStore.save(instance);

        expect(instance.id, equals(1));
      });

      test('saves an existing record', () async {
        final instance = dataStore.create()..key = 'test';

        await dataStore.save(instance);
        instance.key = 'new key';

        expect(
          (instance as SchemaInstance)
              .get(rootSchema.properties.last)!
              .isModified,
          isTrue,
        );

        await dataStore.save(instance);

        expect(
          (instance as SchemaInstance)
              .get(rootSchema.properties.last)!
              .isModified,
          isFalse,
        );

        expect(instance.id, equals(1));
        expect(instance.key, equals('new key'));
      });
    });

    group('delete', () {
      test('deletes a record', () async {
        final instance = dataStore.create()..key = 'test';

        await dataStore.save(instance);
        await dataStore.delete(instance);

        expect(await dataStore.getBy((test) => test.id)(instance.id), isNull);
      });
    });

    group('getBy', () {
      test('returns a record', () async {
        final instance = dataStore.create()..key = 'test';

        await dataStore.save(instance);

        final result = await dataStore.getBy((test) => test.key)(instance.key);

        expect(result?.id, equals(instance.id));
      });
    });

    group('query', () {
      test('returns a list of records', () async {
        final instance1 = dataStore.create()..key = 'test';
        final instance2 = dataStore.create()..key = 'test';

        await dataStore.save(instance1);
        await dataStore.save(instance2);

        final query = dataStore.query()
          ..where((test) => test.key).equals('test');

        final result = await query.getMany();

        expect(result.length, equals(2));
        expect(result.first.id, equals(instance1.id));
        expect(result.last.id, equals(instance2.id));
      });
    });
  });
}
