import 'package:equatable/equatable.dart';
import 'package:wattles/wattles.dart';

class SchemaRelation extends Equatable {
  const SchemaRelation(this.fromProperty, this.otherSchema, this.toProperty);

  final SchemaProperty fromProperty;

  final Schema otherSchema;

  final SchemaProperty toProperty;

  @override
  List<Object?> get props => [fromProperty, otherSchema, toProperty];
}
