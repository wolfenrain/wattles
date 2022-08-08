// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

abstract class _TestStruct extends Struct {
  late int testProperty1;
}

class _TestSchema extends Schema implements _TestStruct {
  _TestSchema() : super(_TestSchema.new, table: 'test') {
    assign(() => testProperty1, fromKey: 'test_property_1');
  }
}

void main() {
  group('QueryBuilder', () {
    late _TestSchema schema;
    late _TestStruct instance;

    setUp(() {
      schema = _TestSchema();
      instance = (_TestSchema().instance() as _TestStruct)..testProperty1 = 1;
    });

    group('getMany', () {
      test('build and execute an empty query', () async {
        final queryBuilder = QueryBuilder<_TestStruct>(schema, (query) async {
          expect(query, equals(Query(const [])));
          return [instance];
        });

        final result = await queryBuilder.getMany();
        expect(result, isA<List<_TestStruct>>());
        expect(result.length, equals(1));
      });

      test('build and execute a query with a where statement', () async {
        final queryBuilder = QueryBuilder<_TestStruct>(schema, (query) async {
          expect(
            query,
            equals(
              Query([
                [Where(schema.properties.first, Operator.equals, 1)]
              ]),
            ),
          );
          return [instance];
        })
          ..where((test) => test.testProperty1).equals(1);

        final result = await queryBuilder.getMany();
        expect(result, isA<List<_TestStruct>>());
        expect(result.length, equals(1));
      });
    });

    group('getOne', () {
      test('build and execute an empty query', () async {
        final queryBuilder = QueryBuilder<_TestStruct>(schema, (query) async {
          expect(query, equals(Query(const [], limit: 1)));
          return [instance];
        });

        final result = await queryBuilder.getOne();
        expect(result, isA<_TestStruct>());
      });

      test('build and execute a query with a where statement', () async {
        final queryBuilder = QueryBuilder<_TestStruct>(schema, (query) async {
          expect(
            query,
            equals(
              Query(
                [
                  [Where(schema.properties.first, Operator.equals, 1)]
                ],
                limit: 1,
              ),
            ),
          );
          return [instance];
        })
          ..where((test) => test.testProperty1).equals(1);

        final result = await queryBuilder.getOne();
        expect(result, isA<_TestStruct>());
      });
    });
  });
}
