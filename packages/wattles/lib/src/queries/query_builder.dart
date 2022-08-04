import 'package:wattles/wattles.dart';

/// {@template query_builder}
/// A builder for creating queries.
/// {@endtemplate}
class QueryBuilder<T extends Struct> {
  /// {@macro query_builder}
  QueryBuilder(this._rootSchema, this._executor);

  final Schema _rootSchema;

  final Future<List<T>> Function(Query) _executor;

  final List<WhereBuilder<T, dynamic>> _wheres = [];

  /// Build a where statement for the query.
  WhereBuilder<T, V> where<V>(V Function(T) whereStatement) {
    final where = WhereBuilder(_rootSchema.queryable(), whereStatement);
    _wheres.add(where);
    return where;
  }

  /// Execute the query.
  Future<List<T>> execute() async {
    final query = Query(_wheres.map((e) => e.build()).toList());
    return _executor(query);
  }

  // TODO: many? one?
}
