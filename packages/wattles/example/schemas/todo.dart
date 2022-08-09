import 'package:wattles/wattles.dart';

import 'schemas.dart';

abstract class Todo extends Struct {
  int? id;

  late String title;

  late bool isCompleted;

  late Owner owner;

  late List<Category> categories;
}

class TodoSchema extends Schema implements Todo {
  TodoSchema() : super(TodoSchema.new, table: 'todos') {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => title, fromKey: 'title');
    assign(() => isCompleted, fromKey: 'completed');

    oneToMany(() => owner).on((owner) => owner.todos);
    manyToMany(() => categories).on((category) => category.todos);
  }
}
