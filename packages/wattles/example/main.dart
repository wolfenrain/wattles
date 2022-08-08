import 'package:wattles/wattles.dart';

import 'todo_repository.dart';

void main() async {
  final dataSource = DataSource.initialize(
    schemas: [
      TodoSchema(),
    ],
    driver: MemoryDriver(),
  );

  final todoRepository = dataSource.getRepository<Todo>();

  /// Create a fresh todo in memory.
  final firstTodo = todoRepository.create()
    ..title = 'Buy milk'
    ..isCompleted = false;

  /// Save the todo to the database.
  await todoRepository.save(firstTodo);

  /// Change the todo and save it again.
  firstTodo.isCompleted = true;
  await todoRepository.save(firstTodo);

  /// Create a query for finding todos.
  final queryBuilder = todoRepository.query()
    ..where((todo) => todo.title)
        .equals('Buy milk')
        .and((todo) => todo.isCompleted)
        .equals(true)
    ..where((todo) => todo.title)
        .equals('Buy bread')
        .and((todo) => todo.isCompleted)
        .equals(true);

  /// Get all todos that match the query.
  final foundTodos = await queryBuilder.getMany();

  /// Loop over the found todos and change them, and save them again.
  for (final todo in foundTodos) {
    todo.isCompleted = false;
    await todoRepository.save(todo);
  }

  /// Delete the first todo.
  await todoRepository.delete(firstTodo);
}
