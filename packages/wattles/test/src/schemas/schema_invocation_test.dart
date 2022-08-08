// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
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

class _MockInvocation extends Mock implements Invocation {}

void main() {
  group('SchemaInvocation', () {
    late _TestSchema schema;
    late Invocation invocation;

    setUp(() {
      schema = _TestSchema();
      invocation = _MockInvocation();
    });

    test('construct a SchemaInvocation from a property', () async {
      final schemaInvocation = SchemaInvocation(() => schema.testProperty1);

      when(() => invocation.memberName).thenReturn(#testProperty1);
      when(() => invocation.isSetter).thenReturn(false);
      when(() => invocation.positionalArguments).thenReturn([]);

      expect(
        schemaInvocation,
        equals(SchemaInvocation.fromInvocation(invocation)),
      );

      verify(() => invocation.memberName).called(1);
      verify(() => invocation.isSetter).called(1);
      verify(() => invocation.positionalArguments).called(1);
    });

    test('fails to construct a SchemaInvocation', () async {
      expect(
        () => SchemaInvocation(() => 'testing'),
        throwsUnimplementedError,
      );
    });

    test('construct a SchemaInvocation from a Invocation ', () {
      when(() => invocation.memberName).thenReturn(#testProperty1);
      when(() => invocation.isSetter).thenReturn(false);
      when(() => invocation.positionalArguments).thenReturn([]);

      final schemaInvocation = SchemaInvocation.fromInvocation(invocation);

      expect(schemaInvocation.memberName, equals('testProperty1'));
      expect(schemaInvocation.isSetter, isFalse);
      expect(schemaInvocation.positionalArguments, isEmpty);

      verify(() => invocation.memberName).called(1);
      verify(() => invocation.isSetter).called(1);
      verify(() => invocation.positionalArguments).called(1);
    });
  });
}
