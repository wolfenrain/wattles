import 'package:wattles/wattles.dart';

/// {@template where_result}
/// Represents the result of a where builder, that can still be chained.
/// {@endtemplate}
class WhereResult<T extends Struct, V> {
  /// {@macro where_result}
  WhereResult(this._queryable, this._where);

  final SchemaQueryable _queryable;

  final Where _where;

  final List<WhereBuilder<T, dynamic>> _ands = [];

  /// Add another clause to the where result.
  WhereBuilder<T, C> and<C>(C Function(T) whereStatement) {
    final where = WhereBuilder<T, C>(_queryable, whereStatement);
    _ands.add(where);
    return where;
  }

  /// Build the where result.
  List<Where> build() {
    return [
      _where,
      for (final and in _ands.where((and) => and.result != null))
        ...and.result!.build()
    ];
  }
}
