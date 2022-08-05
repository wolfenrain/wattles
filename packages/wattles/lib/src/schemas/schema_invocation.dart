import 'package:equatable/equatable.dart';

/// {@template schema_invocation}
///
/// {@endtemplate}
class SchemaInvocation extends Equatable implements Exception {
  /// {@macro schema_invocation}
  ///
  /// Tests the given [func] and if it throws an [SchemaInvocation] it returns
  /// the [SchemaInvocation] otherwise it throws an [UnimplementedError]
  /// stating that the given [func] has not implemented a [SchemaInvocation].
  factory SchemaInvocation(
    Function func, {
    List<dynamic> arguments = const [],
  }) {
    try {
      Function.apply(func, arguments);
    } on SchemaInvocation catch (err) {
      return err;
    }
    throw UnimplementedError(
      'SchemaInvocation not implemented on given function: $func',
    );
  }

  /// {@macro schema_invocation}
  ///
  /// Construct one from a given [Invocation].
  const SchemaInvocation.fromInvocation(this.invocation);

  /// The original invocation.
  final Invocation invocation;

  /// The member name of the invocation.
  String get memberName => invocation.memberName.name;

  /// Whether the invocation is setting a value.
  bool get isSetter => invocation.isSetter;

  /// The positional arguments from the [invocation].
  List<dynamic> get positionalArguments => invocation.positionalArguments;

  @override
  List<Object?> get props => [memberName, isSetter, positionalArguments];
}

final _symbolRegexp = RegExp(r'Symbol\("([a-zA-Z0-9_]+)([=]?)"\)');

extension on Symbol {
  Match? get match => _symbolRegexp.firstMatch('$this');

  String get name => match!.group(1)!;
}
