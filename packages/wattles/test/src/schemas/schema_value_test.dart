// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

void main() {
  group('SchemaValue', () {
    test('returns current value', () {
      final value = SchemaValue(1);
      expect(value.value, equals(1));

      value.value = 2;
      expect(value.value, equals(2));
    });

    group('isModified', () {
      test('becomes modified when value changes', () {
        final value = SchemaValue(1)..value = 2;

        expect(value.isModified, isTrue);
      });

      test('becomes unmodified when value is set to the same value', () {
        final value = SchemaValue(1)..value = 1;

        expect(value.isModified, isFalse);
      });
    });

    group('persist', () {
      test('persists value', () {
        final value = SchemaValue(1)
          ..value = 2
          ..persist();

        expect(value.value, equals(2));
        expect(value.isModified, isFalse);
      });
    });

    test('toString', () {
      final value = SchemaValue(1)..value = 2;

      expect(value.toString(), equals('SchemaValue(old: 1, new: 2)'));
    });
  });
}
