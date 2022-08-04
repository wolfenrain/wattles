import 'package:wattles/wattles.dart';
import 'package:wattles/src/schemas/schema_base.dart';

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
    return _data[property.fromKey];
  }

  /// Set the value of a property.
  ///
  /// This method also validates if the value is valid for the property.
  void set(SchemaProperty property, dynamic value) {
    if (!property.isNullable && value == null) {
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
    return _data[property.fromKey]!.value;
  }

  String toInstanceString() {
    final builder = StringBuffer();
    builder.write('{');
    for (final property in (this as Schema).properties) {
      builder.write('${property.propertyName}: ');
      builder.write(_data[property.fromKey]?.toString());
      if (property != (this as Schema).properties.last) {
        builder.write(', ');
      }
    }
    builder.write('}');
    return builder.toString();
  }
}
