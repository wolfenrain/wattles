import 'package:wattles/wattles.dart';

class OneToOneRelation<T extends Struct> extends Relation<T> {
  OneToOneRelation(super.rootSchema, super.from);

  void on<V extends Struct>(V Function(T) to) {
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
