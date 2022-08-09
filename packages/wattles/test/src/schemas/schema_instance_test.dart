// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

abstract class _TestStruct extends Struct {
  late int testProperty1;

  int? testProperty2;
}

class _TestSchema extends Schema implements _TestStruct {
  _TestSchema() : super(_TestSchema.new, table: 'test') {
    assign(() => testProperty1, fromKey: 'test_property_1');
    assign(() => testProperty2, fromKey: 'test_property_2');
  }
}

void main() {
  group('SchemaInstance', () {
    late _TestSchema schema;
    late SchemaInstance instance;

    setUp(() {
      schema = _TestSchema();
      instance = schema.instance();
    });

    test('is an instance', () async {
      expect(instance.isInstance, isTrue);
    });

    group('value mapping', () {
      test('setting a value based on a property', () {
        (instance as _TestStruct).testProperty1 = 1;

        expect(instance.get(schema.properties.first)?.value, equals(1));
      });

      test('getting a value based on a property', () {
        instance.set(schema.properties.first, 1);

        expect((instance as _TestStruct).testProperty1, equals(1));
      });

      test('overwriting a value based on a property', () {
        (instance as _TestStruct).testProperty1 = 1;

        expect(instance.get(schema.properties.first)?.isModified, isFalse);
        (instance as _TestStruct).testProperty1 = 2;

        expect((instance as _TestStruct).testProperty1, equals(2));
        expect(instance.get(schema.properties.first)?.isModified, isTrue);
      });

      test('throws an error if validation of the setting value fails', () {
        expect(
          () => instance.set(schema.properties.first, null),
          throwsException,
        );
      });

      test('throws an error if validation of the getting value fails', () {
        expect(
          () => instance.get(schema.properties.first),
          throwsException,
        );
      });
    });

    group('toString', () {
      test('returns a string representation of the instance', () {
        instance.set(schema.properties.first, 1);

        expect(
          instance.toString(),
          equals('{testProperty1: 1, testProperty2: null}'),
        );
      });
    });
  });
}
