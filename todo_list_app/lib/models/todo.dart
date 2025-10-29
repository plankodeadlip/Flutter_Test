import 'package:uuid/uuid.dart';
import 'dart:convert';

enum Priority { Low, Medium, High }

class Todo {
  final String id;
  String title;
  String description;
  bool isCompleted;
  final DateTime createdAt;
  DateTime dueDate;
  Priority priority;

  Todo({
    String? id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.dueDate,
    DateTime? createdAt,
    this.priority = Priority.Medium,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Chuyển Todo thành Map (dùng nội bộ hoặc để encode JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.name,
    };
  }

  /// Chuyển Map thành Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: DateTime.parse(map['dueDate']),
      priority: Priority.values.firstWhere(
            (e) => e.name == map['priority'],
        orElse: () => Priority.Medium,
      ),
    );
  }

  /// Hàm dùng để lưu xuống SharedPreferences (JSON string)
  String toJson() => json.encode(toMap());

  /// Hàm dùng để đọc từ SharedPreferences (JSON string)
  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source));

  /// Hàm toggle trạng thái hoàn thành
  void toggleCompleted() {
    isCompleted = !isCompleted;
  }
}
