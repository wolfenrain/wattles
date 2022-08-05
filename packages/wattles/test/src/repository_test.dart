// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

abstract class _TestStruct extends Struct {
  int? id;

  late String key;
}

class _TestSchema extends Schema implements _TestStruct {
  _TestSchema() : super(_TestSchema.new) {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => key, fromKey: 'key');
  }
}

class _TestRepository extends Repository<_TestStruct> {
  _TestRepository() : super(table: 'test', schema: _TestSchema());
}

void main() {
  group('Repository', () {
    late _TestSchema rootSchema;
    late _TestRepository repository;

    setUp(() {
      rootSchema = _TestSchema();
      repository = _TestRepository();
    });

    test('create', () {
      final instance = repository.create()..key = 'test';

      expect(instance.id, isNull);
      expect(instance.key, equals('test'));
    });

    group('save', () {
      test('saves a new record', () async {
        final instance = repository.create()..key = 'test';

        await repository.save(instance);

        expect(instance.id, equals(1));
      });

      test('saves an existing record', () async {
        final instance = repository.create()..key = 'test';

        await repository.save(instance);
        instance.key = 'new key';

        expect(
          (instance as SchemaInstance)
              .get(rootSchema.properties.last)!
              .isModified,
          isTrue,
        );

        await repository.save(instance);

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
        final instance = repository.create()..key = 'test';

        await repository.save(instance);
        await repository.delete(instance);

        expect(await repository.getBy((test) => test.id)(instance.id), isNull);
      });
    });

    group('getBy', () {
      test('returns a record', () async {
        final instance = repository.create()..key = 'test';

        await repository.save(instance);

        final result = await repository.getBy((test) => test.key)(instance.key);

        expect(result?.id, equals(instance.id));
      });
    });

    group('query', () {
      test('returns a list of records', () async {
        final instance1 = repository.create()..key = 'test';
        final instance2 = repository.create()..key = 'test';

        await repository.save(instance1);
        await repository.save(instance2);

        final query = repository.query()
          ..where((test) => test.key).equals('test');

        final result = await query.execute();

        expect(result.length, equals(2));
        expect(result.first.id, equals(instance1.id));
        expect(result.last.id, equals(instance2.id));
      });
    });
  });
}
