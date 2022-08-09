import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

void main() {
  group('NoSchemaFoundError', () {
    test('toString', () {
      expect(
        NoSchemaFoundError<Struct>().toString(),
        equals('No schema found for struct Struct'),
      );
    });
  });
}
