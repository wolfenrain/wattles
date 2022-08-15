import 'package:wattles/wattles.dart';

class ManyToOneRelation<T extends Struct> extends Relation<T> {
  ManyToOneRelation(super.rootSchema, super.property);

  void on<V extends Struct>(List<V> Function(T) inverseSide) {
    rootSchema.relations.add(
      SchemaRelation<T>(
        propertyName: '',
        inverseSide: inverseSide,
        relationType: RelationType.manyToOne,
      ),
    );
  }
}
