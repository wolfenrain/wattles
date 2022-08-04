// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

class _TestStruct extends Struct {
  late int testProperty1;
  late int testProperty2;
}

class _TestSchema extends Schema implements _TestStruct {
  _TestSchema() : super(_TestSchema.new) {
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

    group('equals', () {
      test('where statement can be created', () {
        final whereBuilder = WhereBuilder<_TestStruct, int>(
          schema.queryable(),
          (test) => test.testProperty1,
        ).equals(1);

        expect(
          whereBuilder.build(),
          equals([Where(schema.properties.first, Operator.equals, 1)]),
        );
      });

      test('fails if a previous operator was used', () {
        final whereBuilder = WhereBuilder<_TestStruct, int>(
          schema.queryable(),
          (test) => test.testProperty1,
        ).equals(1);

        expectLater(() => whereBuilder.equals(1), throwsException);
      });
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

    test('fails to build if no operator was used', () {
      final whereBuilder = WhereBuilder<_TestStruct, int>(
        schema.queryable(),
        (test) => test.testProperty1,
      );

      expectLater(whereBuilder.build, throwsException);
    });
  });
}
