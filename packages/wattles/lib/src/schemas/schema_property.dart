import 'package:equatable/equatable.dart';

/// {@template schema_property}
/// Describes a property of a schema.
/// {@endtemplate}
class SchemaProperty extends Equatable implements Exception {
  /// {@macro schema_property}
  const SchemaProperty(
    this.propertyName, {
    required this.fromKey,
    required this.isPrimary,
    required this.isNullable,
  });

  /// The name of the property.
  final String propertyName;

  /// The key to use when reading data from a backend.
  final String fromKey;

  /// Whether the property is the primary key.
  final bool isPrimary;

  /// Whether the property is nullable or not.
  final bool isNullable;

  @override
  List<Object?> get props => [propertyName, fromKey, isPrimary, isNullable];
}
