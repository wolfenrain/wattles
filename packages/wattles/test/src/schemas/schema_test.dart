// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

abstract class _TestStruct extends Struct {
  int? testProperty1;
}

class _TestSchema extends Schema implements _TestStruct {
  _TestSchema() : super(_TestSchema.new, table: 'test');
}

void main() {
  group('Schema', () {
    late _TestSchema schema;

    setUp(() {
      schema = _TestSchema();
    });

    test('has the correct table', () {
      expect(schema.table, equals('test'));
    });

    test('creates an instance', () async {
      expect(schema.instance().isInstance, isTrue);
    });

    test('creates an queryable', () async {
      expect(schema.queryable().isQueryable, isTrue);
    });

    test('assign a property by invocation', () {
      schema.assign(() => schema.testProperty1, fromKey: 'test_property_1');

      expect(
        schema.properties,
        equals([
          SchemaProperty(
            'testProperty1',
            fromKey: 'test_property_1',
            isPrimary: false,
            isNullable: true,
          ),
        ]),
      );
    });

    test('get property by a schema invocation', () {
      schema.assign(() => schema.testProperty1, fromKey: 'test_property_1');

      expect(
        schema.getProperty(SchemaInvocation(() => schema.testProperty1)),
        equals(schema.properties.first),
      );
    });

    group('toString', () {
      test('returns a string representation of the schema', () {
        expect(schema.toString(), equals("Instance of '_TestSchema'"));
      });

      test('calls instance toString', () {
        final instance = schema.instance();
        expect(instance.toString(), equals('{}'));
      });
    });

    test('set data to a schema instance', () {
      schema.assign(() => schema.testProperty1, fromKey: 'test_property_1');
      final instance = schema.instance();

      // Needed as the _TestSchema does not have a assign of it's own.
      (instance as _TestSchema)
          .assign(() => schema.testProperty1, fromKey: 'test_property_1');

      Schema.setAll(schema, instance, {
        'test_property_1': 1,
      });

      expect(instance.testProperty1, equals(1));
    });
  });
}
