import 'package:wattles/wattles.dart';

import 'schemas.dart';

abstract class Book extends Struct {
  int? id;

  late String title;

  late Author author;
}

class BookSchema extends Schema implements Book {
  BookSchema() : super(BookSchema.new, table: 'books') {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => title, fromKey: 'title');

    manyToOne(() => author).on((author) => author.books);
  }
}
