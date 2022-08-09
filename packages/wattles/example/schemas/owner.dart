import 'package:wattles/wattles.dart';

import 'schemas.dart';

abstract class Owner extends Struct {
  int? id;

  late String name;

  late List<Todo> todos;
}

class OwnerSchema extends Schema implements Owner {
  OwnerSchema() : super(OwnerSchema.new, table: 'owners') {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => name, fromKey: 'name');

    // TODO: can't resolve todos cause it was never assigned.
    manyToOne(() => todos).on((todo) => todo.owner);
  }
}
