import 'package:wattles/wattles.dart';

abstract class Todo extends Struct {
  int? id;

  late String title;

  late bool isCompleted;
}

class TodoSchema extends Schema implements Todo {
  TodoSchema() : super(TodoSchema.new, table: 'todos') {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => title, fromKey: 'title');
    assign(() => isCompleted, fromKey: 'completed');
  }
}
