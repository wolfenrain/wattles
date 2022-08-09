import 'package:wattles/wattles.dart';

class ManyToManyRelation<T extends Struct> extends Relation<List<T>> {
  ManyToManyRelation(super.rootSchema, super.from);

  void on<V extends Struct>(List<V> Function(T) to) {
    final fromProperty = rootSchema.getProperty(SchemaInvocation(from));

    final otherSchema = Schema.lookup<T>();

    final toProperty = rootSchema.getProperty(
      SchemaInvocation(() => to(otherSchema as T)),
    );

    rootSchema.relations.add(
      SchemaRelation(fromProperty, otherSchema, toProperty),
    );
  }
}
