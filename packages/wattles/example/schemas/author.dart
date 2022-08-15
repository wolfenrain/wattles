import 'package:wattles/wattles.dart';

import 'schemas.dart';

abstract class Author extends Struct {
  int? id;

  late String name;

  late List<Book> books;
}

class AuthorSchema extends Schema implements Author {
  AuthorSchema() : super(AuthorSchema.new, table: 'authors') {
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => name, fromKey: 'name');

    oneToMany(() => books).on((book) => book.author, byKey: 'author_id');

    // manyToMany(() => books).on(
    //   (p0) => p0.authors,
    //   connectOnTable: 'books_authors',
    //   connectByKey: 'author_id',
    //   connectToKey: 'book_id',
    // );

    // manyToMany(
    //   () => books,
    // )
    //     .on((p0) => p0.authors)
    //     .using<BooksAuthors>(fromKey: sdafasd, toKey: sdfads);
  }
}
