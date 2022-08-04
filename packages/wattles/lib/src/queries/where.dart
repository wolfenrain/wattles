import 'package:wattles/wattles.dart';

/// {@template where}
/// A where for filtering in a [Query].
/// {@endtemplate}
class Where {
  /// {@macro where}
  Where(this.property, this.operator, this.value);

  /// The property to filter on.
  final SchemaProperty property;

  /// The operation to execute.
  final Operator operator;

  /// The value to filter by.
  final dynamic value;
}
