// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

abstract class _TestStruct extends Struct {
  late int testProperty1;
  late int testProperty2;
}

class _TestSchema extends Schema implements _TestStruct {
  _TestSchema() : super(_TestSchema.new, table: 'test') {
    assign(() => testProperty1, fromKey: 'test_property_1');
    assign(() => testProperty2, fromKey: 'test_property_2');
  }
}

void main() {
  group('WhereBuilder', () {
    late _TestSchema schema;

    setUp(() {
      schema = _TestSchema();
    });

    test('equals where statement', () {
      final whereResult = WhereBuilder<_TestStruct, int>(
        schema.queryable(),
        (test) => test.testProperty1,
      ).equals(1);

      expect(
        whereResult.build(),
        equals([Where(schema.properties.first, Operator.equals, 1)]),
      );
    });

    test('not equals where statement', () {
      final whereResult = WhereBuilder<_TestStruct, int>(
        schema.queryable(),
        (test) => test.testProperty1,
      ).notEquals(1);

      expect(
        whereResult.build(),
        equals([Where(schema.properties.first, Operator.notEquals, 1)]),
      );
    });

    test('greater than where statement', () {
      final whereResult = WhereBuilder<_TestStruct, int>(
        schema.queryable(),
        (test) => test.testProperty1,
      ).greaterThan(1);

      expect(
        whereResult.build(),
        equals([Where(schema.properties.first, Operator.greaterThan, 1)]),
      );
    });

    test('greater than or equal where statement', () {
      final whereResult = WhereBuilder<_TestStruct, int>(
        schema.queryable(),
        (test) => test.testProperty1,
      ).greaterThanOrEqual(1);

      expect(
        whereResult.build(),
        equals(
          [Where(schema.properties.first, Operator.greaterThanOrEqual, 1)],
        ),
      );
    });

    test('less than where statement', () {
      final whereResult = WhereBuilder<_TestStruct, int>(
        schema.queryable(),
        (test) => test.testProperty1,
      ).lessThan(1);

      expect(
        whereResult.build(),
        equals([Where(schema.properties.first, Operator.lessThan, 1)]),
      );
    });

    test('less than or equal where statement', () {
      final whereResult = WhereBuilder<_TestStruct, int>(
        schema.queryable(),
        (test) => test.testProperty1,
      ).lessThanOrEqual(1);

      expect(
        whereResult.build(),
        equals([Where(schema.properties.first, Operator.lessThanOrEqual, 1)]),
      );
    });

    test('can chain multiple where statements', () {
      final whereBuilder = WhereBuilder<_TestStruct, int>(
        schema.queryable(),
        (test) => test.testProperty1,
      ).equals(1);

      final secondBuilder =
          whereBuilder.and((test) => test.testProperty2).equals(3);

      expect(
        whereBuilder.build(),
        equals([
          Where(schema.properties.first, Operator.equals, 1),
          Where(schema.properties.last, Operator.equals, 3),
        ]),
      );

      expect(whereBuilder, isNot(equals(secondBuilder)));
    });
  });
}
