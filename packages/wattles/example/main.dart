import 'package:wattles/wattles.dart';

import 'drivers/fake_sql_driver.dart';
import 'schemas/schemas.dart';

void main() async {
  final dataSource = DataSource.initialize(
    schemas: [
      AuthorSchema(),
      BookSchema(),
    ],
    driver: FakeSqlDriver(),
  );

  final authorStore = dataSource.getStore<Author>();
  final bookStore = dataSource.getStore<Book>();

  final authorQuery = authorStore.query();
  await authorQuery.getMany();

  final bookQuery = bookStore.query();
  await bookQuery.getMany();

  // // Create a new author.
  // final author = authorStore.create()..name = 'John Doe';
  // await authorStore.save(author);

  // // Create a new book.
  // final book = bookStore.create()
  //   ..title = 'The Great Book'
  //   ..author = author;
  // await bookStore.save(book);
}
