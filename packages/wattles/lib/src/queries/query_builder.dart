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
  WhereBuilder<T, V> where<V>(V Function(T) keyResolver) {
    final where = WhereBuilder(_rootSchema.queryable(), keyResolver);
    _wheres.add(where);
    return where;
  }

  /// Execute the query and get all the results.
  Future<List<T>> getMany() async {
    final query = Query(_wheres.map((e) => e.result!.build()).toList());
    return _executor(query);
  }

  /// Execute the query and get the first result.
  Future<T?> getOne() async {
    final query = Query(
      _wheres
          .where((e) => e.result != null)
          .map((e) => e.result!.build())
          .toList(),
      limit: 1,
    );
    final results = await _executor(query);
    return results.isEmpty ? null : results.first;
  }
}
