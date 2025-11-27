import 'package:nylo_framework/nylo_framework.dart';
import 'package:json_annotation/json_annotation.dart';
import '../todo.dart';

part 'todos_response.g.dart';
@JsonSerializable()
class TodosResponse extends Model {
  final bool success;
  final TodosData data;

  TodosResponse({
    required this.success,
    required this.data
  });

  factory TodosResponse.fromJson(Map<String, dynamic> json) =>
      _$TodosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TodosResponseToJson(this);
}

@JsonSerializable()
class TodosData {
  final List<Todo> todos;
  final Pagination pagination;

  TodosData({required this.todos, required this.pagination});

  factory TodosData.fromJson(Map<String, dynamic> json) =>
      _$TodosDataFromJson(json);
  Map<String, dynamic> toJson() => _$TodosDataToJson(this);
}

@JsonSerializable()
class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalTodos;
  final bool hasNextPage;
  final bool hasPrevPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalTodos,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}