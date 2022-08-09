import 'package:wattles/wattles.dart';

import 'schemas.dart';

abstract class Category extends Struct {
  int? id;

  late String name;

  late List<Todo> todos;
}

class CategorySchema extends Schema implements Owner {
  CategorySchema() : super(CategorySchema.new, table: 'categories') {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => name, fromKey: 'name');

    manyToMany(() => todos).on((todo) => todo.categories);
  }
}
