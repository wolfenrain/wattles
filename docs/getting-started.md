# Getting Started 🚀

## Prerequisites 📝

In order to use Wattles you must have the [Dart SDK][dart_installation_link] installed on your machine.

> **Note**: Wattles requires Dart `">=2.17.0 <3.0.0"`

## Installing 🧑‍💻

Let's start by installing the [`wattles`](https://pub.dev/packages/wattles) package, which is the core package.

```shell
# 📦 Install the wattles package from pub.dev
dart pub add wattles
```

## Defining `Struct`s and `Schema`s

`Struct`s are the strongly typed representation of how we want to interact with our data. Lets define a Todo `Struct`:

```dart
// By extending from Struct we tell Wattles that this class is our strongly typed interface.
abstract class Todo extends Struct {
  // Because id is nullable, we don't have to define it as late.
  int? id;

  // By defining this as a non-nullable String we ensure that this value won't 
  // ever be null. Wattles can use this to validate in coming data from the 
  // database!
  late String title;

  late bool isCompleted;
}
```

> **Note**: We can name properties on a `Struct` that don't directly have to match the same naming convention of our data source, this allows us to have the front facing code more in-line with what we would want in our application.

Now that we have our `Struct` defined we can create a `Schema` to map the `Todo` to the database: 

```dart
// We extends Schema and implement our Todo struct so that Wattles knows that 
// this is the schema for the Todo and it can ensure everything will be 
// strongly typed.
class TodoSchema extends Schema implements Todo {
  TodoSchema() : super(TodoSchema.new) {
    // We map our properties to their data representation, and we can even 
    // define some extra meta data for them.
    assign(() => id, fromKey: 'id', isPrimary: true);
    assign(() => title, fromKey: 'title');
    // We can even define properties that have a different name in the 
    // database.
    assign(() => isCompleted, fromKey: 'completed');
  }
}
```

[dart_installation_link]: https://dart.dev/get-dart