import 'dart:io';

import 'todo_repository.dart';

void main() async {
  final todoRepository = TodoRepository();

  final firstTodo = todoRepository.create()
    ..title = 'Buy milk'
    ..isCompleted = false;
  stdout.writeln('Created todo: $firstTodo');

  await todoRepository.save(firstTodo);
  stdout.writeln('Saved todo: $firstTodo');

  firstTodo.isCompleted = true;
  await todoRepository.save(firstTodo);
  stdout.writeln('Updated todo: $firstTodo');

  final queryBuilder = todoRepository.query()
    ..where((todo) => todo.title)
        .equals('Buy milk')
        .and((todo) => todo.isCompleted)
        .equals(true)
    ..where((todo) => todo.title)
        .equals('Buy bread')
        .and((todo) => todo.isCompleted)
        .equals(true);

  final foundTodos = await queryBuilder.execute();
  stdout.writeln('Found todos: $foundTodos');
  for (final todo in foundTodos) {
    todo.isCompleted = false;
    await todoRepository.save(todo);
  }
  stdout.writeln('Updated todos: $foundTodos');

  final todo = await todoRepository.getBy((todo) => todo.title)('Buy milk');
  stdout.writeln('Found todo by key: $todo');
}
