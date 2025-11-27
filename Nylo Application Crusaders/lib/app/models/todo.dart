import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/requests/update_todo_request.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

import '../controllers/todo_controller.dart';
import 'requests/create_todo_request.dart';

part 'todo.g.dart';

enum Priority { low, medium, high }

class PriorityConverter implements JsonConverter<Priority, String> {
  const PriorityConverter();

  @override
  Priority fromJson(String json) {
    switch (json.toLowerCase()) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        return Priority.medium; // Default fallback
    }
  }

  @override
  String toJson(Priority object) {
    return object.name; // Low, Medium, High
  }
}

// ============================================
// Todo Model
// ============================================

@JsonSerializable()
class Todo extends Model {
  final String id;
  final String userId;
  String title;
  String description;

  @PriorityConverter()
  Priority priority;
  DateTime dueDate;
  String category;
  bool completed;
  DateTime createdAt;
  DateTime? updateAt;
  DateTime? completedAt;

  static final _controller = TodoController();

  Todo({
    String? id,
    required this.userId,
    required this.title,
    required this.description,
    this.priority = Priority.medium,
    required this.dueDate,
    required this.category,
    this.completed = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  // ============================================
  // Instance Methods
  // ============================================

  Future<Todo?> toggleCompleted() async {
    try {
      final toggled = await _controller.toggleTodo(id);
      if (toggled != null) {
        // Update current instance
        completed = toggled.completed;
        completedAt = toggled.completedAt;
        updateAt = DateTime.now();
        print(
          "✅ Toggle thành công: $title -> ${completed ? 'Completed' : 'Pending'}",
        );
      }
      return toggled;
    } catch (e) {
      print("❌ Error toggle todo: $e");
      return null;
    }
  }

  Future<bool> update(UpdateTodoRequest request) async {
    try {
      final result = await _controller.updateTodo(id, request);

      if (result != null) {
        // Update current instance với data mới
        if (request.title != null) title = request.title!;
        if (request.description != null) description = request.description!;
        if (request.priority != null) {
          priority = PriorityConverter().fromJson(request.priority!);
        }
        if (request.dueDate != null) dueDate = request.dueDate!;
        if (request.category != null) category = request.category!;
        if (request.completed != null) completed = request.completed!;
        updateAt = DateTime.now();

        print("✅ Update thành công: $title");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error update todo: $e");
      return false;
    }
  }

  Future<bool> updateFields(Map<String, dynamic> data) async {
    try {
      final request = UpdateTodoRequest(
        title: data['title'],
        description: data['description'],
        priority: data['priority'],
        dueDate: data['dueDate'],
        category: data['category'],
        completed: data['completed'],
      );

      return await update(request);
    } catch (e) {
      print("❌ Error update fields: $e");
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      final deleted = await _controller.deleteTodo(id);
      if (deleted) {
        print("✅ Delete thành công: $title");
      }
      return deleted;
    } catch (e) {
      print("❌ Error delete todo: $e");
      return false;
    }
  }

  // ============================================
  // Static Methods
  // ============================================

  static Future<List<Todo>?> loadAll({int page = 1, int limit = 10}) async {
    try {
      final response = await _controller.getTodos(page: page, limit: limit);
      return response?.data.todos;
    } catch (e) {
      print("❌ Error load todos: $e");
      return null;
    }
  }

  static Future<Todo?> create(CreateTodoRequest request) async {
    try {
      return await _controller.createToDo(request);
    } catch (e) {
      print("❌ Error create todo: $e");
      return null;
    }
  }

  static Future<List<Todo>?> loadByStatus({
    required bool completed,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _controller.getTodosByStatus(
        completed: completed,
        page: page,
        limit: limit,
      );
    } catch (e) {
      print("❌ Error load by status: $e");
      return null;
    }
  }

  static Future<List<Todo>?> loadByPriority({
    required Priority priority,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      return await _controller.getTodosByPriority(
        priority: priority,
        page: page,
        limit: limit,
      );
    } catch (e) {
      print("❌ Error load by priority: $e");
      return null;
    }
  }

  // ============================================
  // Helper Methods
  // ============================================

  /// Check if todo is overdue
  bool get isOverdue {
    if (completed) return false;
    return DateTime.now().isAfter(dueDate);
  }

  /// Check if todo is due today
  bool get isDueToday {
    if (completed) return false;
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  /// Check if todo is due soon (within 3 days)
  bool get isDueSoon {
    if (completed) return false;
    final difference = dueDate.difference(DateTime.now());
    return difference.inDays >= 0 && difference.inDays <= 3;
  }

  int get daysUntilDue {
    return dueDate.difference(DateTime.now()).inDays;
  }

  /// Get formatted due date string
  String get formattedDueDate {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (completed) {
      return "Đã hoàn thành";
    } else if (difference.isNegative) {
      return "Quá hạn ${difference.inDays.abs()} ngày";
    } else if (difference.inDays == 0) {
      return "Hôm nay";
    } else if (difference.inDays == 1) {
      return "Ngày mai";
    } else if (difference.inDays < 7) {
      return "Còn ${difference.inDays} ngày";
    } else {
      return "Còn ${(difference.inDays / 7).floor()} tuần";
    }
  }

  IconData get priorityIcon {
    switch (priority) {
      case Priority.high:
        return Icons.priority_high;
      case Priority.medium:
        return Icons.remove;
      case Priority.low:
        return Icons.low_priority;
    }
  }

  /// Get priority color
  Color get priorityColor {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'study':
        return Icons.school;
      case 'personal':
        return Icons.person;
      case 'shopping':
        return Icons.shopping_cart;
      case 'health':
        return Icons.favorite;
      default:
        return Icons.task;
    }
  }

  Todo copyWith({
    String? title,
    String? description,
    Priority? priority,
    DateTime? dueDate,
    String? category,
    bool? completed,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return Todo(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      completed: completed ?? this.completed,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updateAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  String toString() {
    return 'Todo{id: $id, title: $title, completed: $completed, priority: ${priority.name}}';
  }
}
