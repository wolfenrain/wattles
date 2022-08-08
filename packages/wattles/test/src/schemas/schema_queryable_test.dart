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
  group('SchemaQueryable', () {
    late _TestSchema schema;
    late SchemaQueryable queryable;

    setUp(() {
      schema = _TestSchema();
      queryable = schema.queryable();
    });

    test('is a queryable', () async {
      expect(queryable.isQueryable, isTrue);
    });

    test('throws as SchemaProperty when trying to access a property', () async {
      expect(
        () => (queryable as _TestStruct).testProperty1,
        throwsA(
          equals(
            SchemaProperty(
              'testProperty1',
              fromKey: 'test_property_1',
              isPrimary: false,
              isNullable: false,
            ),
          ),
        ),
      );
    });
  });
}
