// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

abstract class _TestStruct extends Struct {
  late int testProperty1;
}

class _TestSchema extends Schema implements _TestStruct {
  _TestSchema() : super(_TestSchema.new) {
    assign(() => testProperty1, fromKey: 'test_property_1');
  }
}

void main() {
  group('QueryBuilder', () {
    late _TestSchema schema;

    setUp(() {
      schema = _TestSchema();
    });

    test('build and execute an empty query', () async {
      final queryBuilder = QueryBuilder<_TestStruct>(schema, (query) async {
        expect(query, equals(Query(const [])));
        return [];
      });

      expect(await queryBuilder.execute(), isA<List<_TestStruct>>());
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
        return [];
      })
        ..where((test) => test.testProperty1).equals(1);

      expect(await queryBuilder.execute(), isA<List<_TestStruct>>());
    });
  });
}
