# Getting Started 🚀

## Prerequisites 📝

In order to use Wattle(s) you must have the [Dart SDK][dart_installation_link] installed on your machine.

> **Note**: Wattle(s) requires Dart `">=2.17.0 <3.0.0"`

## Installing 🧑‍💻

Let's start by installing the [`wattles`](https://pub.dev/packages/wattles) package, this package comes with all the core functionality to get started.

```shell
# 📦 Install the wattles package from pub.dev
dart pub add wattles
```

## Defining `Struct`s and `Schema`s 🏗️

`Struct`s are the strongly typed representation of how we want to interact with our data. They are used as an interface and therefore should never be initialized directly. 

Lets define a Todo `Struct`:

```dart
// By extending from Struct we tell Wattle(s) that this class is our strongly typed interface.
abstract class Todo extends Struct {
  // Because id is nullable, we don't have to define it as late.
  int? id;

  // By defining this as a non-nullable String we ensure that this value won't 
  // ever be null. Wattle(s) can use this to validate incoming data from the 
  // database!
  late String title;

  late bool isCompleted;
}
```

> **Note**: We can name properties on a `Struct` that don't directly have to match the same naming convention on the data source, this allows us to have the front facing code more in-line with what we would want in our application.

Now that we have our `Struct` defined we can create a `Schema` to map the `Todo` to the database: 

```dart
// We extends Schema and implement our Todo struct so that Wattle(s) knows that 
// this is the schema for our Todo and by doing so everything will be strongly 
// typed.
class TodoSchema extends Schema implements Todo {
  // The super call receives the schema's constructor and what table will 
  // hold the data we need.
  TodoSchema() : super(TodoSchema.new, table: 'todos') {
    // We map each of the properties to their data representation, and we can 
    // even define extra meta data if required.
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => title, fromKey: 'title');
    assign(() => isCompleted, fromKey: 'completed');
  }
}
```

[dart_installation_link]: https://dart.dev/get-dart