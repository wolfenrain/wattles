import 'package:wattles/wattles.dart';

/// {@template query}
/// A query for selecting data from a database.
/// {@endtemplate}
class Query {
  /// {@macro query}
  const Query(this.wheres);

  /// The where statements for the query.
  ///
  /// Each list element is an OR based where statement.
  final List<List<Where>> wheres;
}
