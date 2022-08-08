import 'package:wattles/wattles.dart';

abstract class Todo extends Struct {
  int? id;

  late String title;

  late bool isCompleted;
}

class _TodoSchema extends Schema implements Todo {
  _TodoSchema() : super(_TodoSchema.new) {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => title, fromKey: 'title');
    assign(() => isCompleted, fromKey: 'completed');
  }
}

class TodoRepository extends Repository<Todo> {
  TodoRepository() : super(table: 'todos', schema: _TodoSchema());
}
