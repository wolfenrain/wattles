import 'package:wattles/wattles.dart';

class OneToManyRelation<T extends Struct> extends Relation<List<T>> {
  OneToManyRelation(super.rootSchema, super.property);

  void on<V extends Struct>(
    V Function(T) inverseSide, {
    required String byKey,
  }) {
    rootSchema.relations.add(
      SchemaRelation<T>(
        propertyName: byKey,
        inverseSide: inverseSide,
        relationType: RelationType.oneToMany,
      ),
    );
    // final onProperty = SchemaProperty(
    //   SchemaInvocation(typeFunction).memberName,
    //   fromKey: byKey,
    //   isPrimary: false,
    //   isNullable: '$T'.endsWith('?'),
    // );

    // final target = Schema.lookup<T>();

    // final inverseSideProperty = SchemaProperty(
    //   SchemaInvocation(() => inverseSide(target as T)).memberName,
    //   fromKey: byKey,
    //   isPrimary: false,
    //   isNullable: '$T'.endsWith('?'),
    // );

    // rootSchema.relations.add(
    //   SchemaRelation(
    //     target: target,
    //     onProperty: onProperty,
    //     inverSideProperty: inverseSideProperty,
    //     relationType: RelationType.oneToMany,
    //   ),
    // );
  }
}
