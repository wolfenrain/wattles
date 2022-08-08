// ignore_for_file: avoid_returning_this

import 'package:meta/meta.dart';
import 'package:wattles/wattles.dart';

/// {@template where_builder}
/// A builder for creating where statements.
/// {@endtemplate}
class WhereBuilder<T extends Struct, V> {
  /// {@macro where_builder}
  WhereBuilder(this._queryable, this._keyResolver);

  final SchemaQueryable _queryable;

  @protected
  WhereResult<T, V>? result;

  final V Function(T) _keyResolver;

  /// Turn the where into a equals statement.
  WhereResult<T, V> equals(V v) => resolve(Operator.equals, v);

  /// Turn the where into a not equals statement.
  WhereResult<T, V> notEquals(V v) => resolve(Operator.notEquals, v);

  /// Resolves the given operator and value into a where result.
  ///
  /// This method can be mocked to validated that methods on extensions are
  /// called correctly.
  @visibleForTesting
  WhereResult<T, V> resolve(Operator operator, V v) {
    try {
      _keyResolver(_queryable as T);
    } on SchemaProperty catch (e) {
      return result ??= WhereResult(
        _queryable,
        Where(e, operator, v),
      );
    }
    // TODO: proper error
    throw Exception('Where not supported on key resolver.');
  }
}

/// Extension on [WhereBuilder] for numerical types.
extension WhereBuilderNum<T extends Struct, V extends num?>
    on WhereBuilder<T, V> {
  /// Turn the where into a greater than statement.
  WhereResult<T, V> greaterThan(V v) => resolve(Operator.greaterThan, v);

  /// Turn the where into a greater than or equal statement.
  WhereResult<T, V> greaterThanOrEqual(V v) =>
      resolve(Operator.greaterThanOrEqual, v);

  /// Turn the where into a less than statement.
  WhereResult<T, V> lessThan(V v) => resolve(Operator.lessThan, v);

  /// Turn the where into a less than or equal statement.
  WhereResult<T, V> lessThanOrEqual(V v) =>
      resolve(Operator.lessThanOrEqual, v);
}
