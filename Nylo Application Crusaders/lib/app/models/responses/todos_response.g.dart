// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodosResponse _$TodosResponseFromJson(Map<String, dynamic> json) =>
    TodosResponse(
      success: json['success'] as bool,
      data: TodosData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TodosResponseToJson(TodosResponse instance) =>
    <String, dynamic>{'success': instance.success, 'data': instance.data};

TodosData _$TodosDataFromJson(Map<String, dynamic> json) => TodosData(
  todos: (json['todos'] as List<dynamic>)
      .map((e) => Todo.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TodosDataToJson(TodosData instance) => <String, dynamic>{
  'todos': instance.todos,
  'pagination': instance.pagination,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  currentPage: (json['currentPage'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  totalTodos: (json['totalTodos'] as num).toInt(),
  hasNextPage: json['hasNextPage'] as bool,
  hasPrevPage: json['hasPrevPage'] as bool,
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalTodos': instance.totalTodos,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };
