// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

void main() {
  group('SchemaProperty', () {
    test('can be initialized', () async {
      final property = SchemaProperty(
        'propertyName',
        fromKey: 'fromKey',
        isPrimary: true,
        isNullable: false,
      );

      expect(property.propertyName, equals('propertyName'));
      expect(property.fromKey, equals('fromKey'));
      expect(property.isPrimary, isTrue);
      expect(property.isNullable, isFalse);

      expect(
        property,
        equals(
          SchemaProperty(
            'propertyName',
            fromKey: 'fromKey',
            isPrimary: true,
            isNullable: false,
          ),
        ),
      );
    });
  });
}
