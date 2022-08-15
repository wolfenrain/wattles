import 'package:meta/meta.dart';
import 'package:wattles/wattles.dart';

abstract class Relation<T> {
  Relation(
    this.rootSchema,
    this.property,
  );

  @protected
  final T Function() property;

  @protected
  final Schema rootSchema;
}
