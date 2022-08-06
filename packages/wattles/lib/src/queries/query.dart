import 'package:equatable/equatable.dart';
import 'package:wattles/wattles.dart';

/// {@template query}
/// A query for selecting data from a database.
/// {@endtemplate}
class Query extends Equatable {
  /// {@macro query}
  const Query(this.wheres, {this.limit});

  /// The where statements for the query.
  ///
  /// Each list element is an OR based where statement.
  final List<List<Where>> wheres;

  /// The amount of results to limit the query to.
  final int? limit;

  @override
  List<Object?> get props => [wheres, limit];
}
