import 'package:nylo_framework/nylo_framework.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_todo_request.g.dart';

@JsonSerializable()
class UpdateTodoRequest extends Model {
  final String? title;
  final String? description;
  final String? priority;
  final DateTime? dueDate;
  final String? category;
  final bool? completed;

  UpdateTodoRequest({
    this.title,
    this.description,
    this.priority,
    this.dueDate,
    this.category,
    this.completed,
  });

  factory UpdateTodoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTodoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTodoRequestToJson(this);
}
