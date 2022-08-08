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
  group('DataSource', () {
    test('initialize correctly', () {
      final dataSource = DataSource.initialize(
        schemas: [_TestSchema()],
        driver: MemoryDriver(),
      );

      expect(dataSource.schemas.length, equals(1));
      expect(dataSource.schemas.first, isA<_TestSchema>());
    });

    group('getStore', () {
      test('gets a DataStore instance for given schema', () {
        final dataSource = DataSource.initialize(
          schemas: [_TestSchema()],
          driver: MemoryDriver(),
        );

        final store = dataSource.getStore<_TestStruct>();

        expect(store, isA<DataStore<_TestStruct>>());
      });

      test('throws an exception if schema is not found', () {
        final dataSource = DataSource.initialize(
          schemas: [],
          driver: MemoryDriver(),
        );

        expect(
          () => dataSource.getStore<_TestStruct>(),
          throwsA(
            isA<Exception>().having(
              (p0) => p0.toString(),
              'description',
              contains('No schema found for type _TestStruct'),
            ),
          ),
        );
      });

      test('throws an exception if schema is not found', () {
        final dataSource = DataSource.initialize(
          schemas: [_TestSchema(), _TestSchema()],
          driver: MemoryDriver(),
        );

        expect(
          () => dataSource.getStore<_TestStruct>(),
          throwsA(
            isA<Exception>().having(
              (p0) => p0.toString(),
              'description',
              contains('Multiple schemas found for type _TestStruct'),
            ),
          ),
        );
      });
    });
  });
}
