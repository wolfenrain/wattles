import 'package:test/test.dart';
import 'package:wattles/wattles.dart';

void main() {
  group('TooManySchemasFoundError', () {
    test('toString', () {
      expect(
        TooManySchemasFoundError<Struct>().toString(),
        equals('Too many schemas found for struct Struct'),
      );
    });
  });
}
