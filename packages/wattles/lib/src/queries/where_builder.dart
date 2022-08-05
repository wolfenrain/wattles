// ignore_for_file: avoid_returning_this

import 'package:wattles/wattles.dart';

/// {@template where_builder}
/// A builder for creating where statements.
/// {@endtemplate}
class WhereBuilder<T, V> {
  /// {@macro where_builder}
  WhereBuilder(this._queryable, this._whereStatement);

  final List<WhereBuilder<T, dynamic>> _ands = [];

  Where? _result;

  final SchemaQueryable _queryable;

  final V Function(T) _whereStatement;

  /// Turn the where into a equal operator where statement.
  WhereBuilder<T, V> equals(V value) {
    if (_result != null) {
      // TODO(wolfen): better error?
      throw Exception('Where already built.');
    }
    try {
      _whereStatement(_queryable as T);
    } on SchemaProperty catch (e) {
      _result = Where(e, Operator.equals, value);
    }
    return this;
  }

  /// Add another clause to the where statement.
  WhereBuilder<T, C> and<C>(C Function(T) whereStatement) {
    final where = WhereBuilder(_queryable, whereStatement);
    _ands.add(where);
    return where;
  }

  /// Build the where statement.
  List<Where> build() {
    if (_result == null) {
      // TODO(wolfen): better error?
      throw Exception('Where not built.');
    }
    return [_result!, for (final and in _ands) ...and.build()];
  }
}
