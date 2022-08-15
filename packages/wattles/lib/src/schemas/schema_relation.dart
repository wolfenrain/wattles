import 'package:equatable/equatable.dart';
import 'package:wattles/wattles.dart';

class SchemaRelation<T extends Struct> extends Equatable {
  const SchemaRelation({
    required this.propertyName,
    required this.relationType,
    required this.inverseSide,
  });

  final String propertyName;

  final dynamic Function(T) inverseSide;

  final RelationType relationType;

  Schema get target => Schema.lookup<T>();

  @override
  List<Object?> get props => [relationType, inverseSide];
}

enum RelationType {
  oneToMany,
  manyToOne,
}
