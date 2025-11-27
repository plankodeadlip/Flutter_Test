// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoStatsResponse _$TodoStatsResponseFromJson(Map<String, dynamic> json) =>
    TodoStatsResponse(
      success: json['success'] as bool,
      data: TodoStatsData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TodoStatsResponseToJson(TodoStatsResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

TodoStatsData _$TodoStatsDataFromJson(Map<String, dynamic> json) =>
    TodoStatsData(stats: Stats.fromJson(json['stats'] as Map<String, dynamic>));

Map<String, dynamic> _$TodoStatsDataToJson(TodoStatsData instance) =>
    <String, dynamic>{'stats': instance.stats};

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
  total: (json['total'] as num).toInt(),
  completed: (json['completed'] as num).toInt(),
  pending: (json['pending'] as num).toInt(),
  overdue: (json['overdue'] as num).toInt(),
  byPriority: (json['byPriority'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  byCategory: (json['byCategory'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
);

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
  'total': instance.total,
  'completed': instance.completed,
  'pending': instance.pending,
  'overdue': instance.overdue,
  'byPriority': instance.byPriority,
  'byCategory': instance.byCategory,
};
