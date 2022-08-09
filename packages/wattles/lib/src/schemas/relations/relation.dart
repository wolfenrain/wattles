import 'package:meta/meta.dart';
import 'package:wattles/wattles.dart';

abstract class Relation<T> {
  Relation(
    this.rootSchema,
    this.from,
  );

  @protected
  final T Function() from;

  @protected
  final Schema rootSchema;
}
