// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_todo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTodoRequest _$UpdateTodoRequestFromJson(Map<String, dynamic> json) =>
    UpdateTodoRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      priority: json['priority'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      category: json['category'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$UpdateTodoRequestToJson(UpdateTodoRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'dueDate': instance.dueDate?.toIso8601String(),
      'category': instance.category,
      'completed': instance.completed,
    };
