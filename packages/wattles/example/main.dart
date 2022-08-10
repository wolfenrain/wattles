import 'package:wattles/wattles.dart';

import 'drivers/fake_sql_driver.dart';
import 'schemas/schemas.dart';

void main() async {
  final dataSource = DataSource.initialize(
    schemas: [
      OwnerSchema(),
      CategorySchema(),
      TodoSchema(),
    ],
    driver: FakeSqlDriver(),
  );

  final todoStore = dataSource.getStore<Todo>();

  /// Create a fresh todo in memory.
  final firstTodo = todoStore.create()
    ..title = 'Buy milk'
    ..isCompleted = false;

  /// Save the todo to the database.
  await todoStore.save(firstTodo);

  /// Change the todo and save it again.
  firstTodo.isCompleted = true;
  await todoStore.save(firstTodo);

  /// Create a query for finding todos.
  final queryBuilder = todoStore.query()
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
    await todoStore.save(todo);
  }

  /// Delete the first todo.
  await todoStore.delete(firstTodo);
}
