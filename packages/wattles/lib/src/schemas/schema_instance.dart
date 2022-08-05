import 'package:wattles/src/schemas/schema_base.dart';
import 'package:wattles/wattles.dart';

/// {@template schema_instance}
/// An instance of a schema that holds data.
///
/// Front-facing it is a [Struct] while mapping all properties to the [_data].
/// {@endtemplate}
mixin SchemaInstance on SchemaBase {
  /// Indicates if this [SchemaBase] was created as an instance or not.
  bool isInstance = false;

  final Map<String, SchemaValue> _data = {};

  /// Get the value of a property.
  SchemaValue? get(SchemaProperty property) {
    final value = _data[property.fromKey];
    if (!property.isNullable && (value == null || value.value == null)) {
      // TODO(wolfen): better errors
      throw Exception(
        '''
Property ${property.propertyName} is non nullable but is currently null.

Did you forget to assign a value to it?''',
      );
    }
    return _data[property.fromKey];
  }

  /// Set the value of a property.
  ///
  /// This method also validates if the value is valid for the property.
  void set(SchemaProperty property, dynamic value) {
    if (!property.isNullable && value == null) {
      // TODO(wolfen): proper error handling.
      throw Exception('Property ${property.propertyName} is not nullable');
    }
    if (!_data.containsKey(property.fromKey)) {
      _data[property.fromKey] = SchemaValue(value);
    } else {
      _data[property.fromKey]!.value = value;
    }
  }

  /// Handle the [noSuchMethod] for the instance schemas.
  dynamic noSuchInstanceMethod(SchemaInvocation invocation) {
    final property = (this as Schema).getProperty(invocation);
    if (invocation.isSetter) {
      set(property, invocation.positionalArguments[0]);
    }
    return get(property)?.value;
  }

  /// Create a string representation of the instance.
  String toInstanceString() {
    return [
      '{',
      for (final prop in (this as Schema).properties) ...[
        '${prop.propertyName}: ${_data[prop.fromKey]?.value.toString()}',
        if (prop != (this as Schema).properties.last) ', ',
      ],
      '}'
    ].join();
  }
}
