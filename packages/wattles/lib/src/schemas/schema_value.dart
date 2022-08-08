import 'package:wattles/wattles.dart';

/// {@template schema_value}
/// Represents a value in a [SchemaInstance].
///
/// It keeps track of the modified state of the value.
/// {@endtemplate}
class SchemaValue {
  /// {@macro schema_value}
  SchemaValue(this._oldValue) : value = _oldValue;

  dynamic _oldValue;

  /// The current value of the schema value.
  dynamic value;

  /// Returns true if this schema value has been modified.
  bool get isModified => _oldValue != value;

  /// Persist the new value to the old value.
  void persist() => _oldValue = value;

  @override
  String toString() => 'SchemaValue(old: $_oldValue, new: $value)';
}
