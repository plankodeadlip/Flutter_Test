import 'package:nylo_framework/nylo_framework.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_stats_response.g.dart';

@JsonSerializable()
class TodoStatsResponse extends Model {
  final bool success;
  final TodoStatsData data;

  TodoStatsResponse({
    required this.success,
    required this.data
  });

  factory TodoStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$TodoStatsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TodoStatsResponseToJson(this);
}

@JsonSerializable()
class TodoStatsData {
  final Stats stats;

  TodoStatsData({required this.stats});

  factory TodoStatsData.fromJson(Map<String, dynamic> json) =>
      _$TodoStatsDataFromJson(json);
  Map<String, dynamic> toJson() => _$TodoStatsDataToJson(this);
}

@JsonSerializable()
class Stats {
  final int total;
  final int completed;
  final int pending;
  final int overdue;
  final Map<String, int>? byPriority;
  final Map<String, int>? byCategory;

  Stats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.overdue,
    this.byPriority,
    this.byCategory,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
  Map<String, dynamic> toJson() => _$StatsToJson(this);
}