// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) =>
    Todo(
        id: json['id'] as String?,
        userId: json['userId'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        priority: json['priority'] == null
            ? Priority.medium
            : const PriorityConverter().fromJson(json['priority'] as String),
        dueDate: DateTime.parse(json['dueDate'] as String),
        category: json['category'] as String,
        completed: json['completed'] as bool? ?? false,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        completedAt: json['completedAt'] == null
            ? null
            : DateTime.parse(json['completedAt'] as String),
      )
      ..updateAt = json['updateAt'] == null
          ? null
          : DateTime.parse(json['updateAt'] as String);

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'description': instance.description,
  'priority': const PriorityConverter().toJson(instance.priority),
  'dueDate': instance.dueDate.toIso8601String(),
  'category': instance.category,
  'completed': instance.completed,
  'createdAt': instance.createdAt.toIso8601String(),
  'updateAt': instance.updateAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};
