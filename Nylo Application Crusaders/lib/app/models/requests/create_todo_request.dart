import 'package:nylo_framework/nylo_framework.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_todo_request.g.dart';

@JsonSerializable()
class CreateTodoRequest extends Model {
  final String title;
  final String? description;
  final String? priority;
  final DateTime? dueDate;
  final String? category;
  final bool? completed;

  CreateTodoRequest({
    required this.title,
    this.description,
    this.priority,
    this.dueDate,
    this.category,
    this.completed,
  });

  factory CreateTodoRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTodoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTodoRequestToJson(this);
}
