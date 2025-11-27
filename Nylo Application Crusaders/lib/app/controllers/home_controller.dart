import 'package:flutter/material.dart';
import '../models/todo.dart';
import '/app/controllers/controller.dart';
import '/app/controllers/todo_controller.dart';
import '../models/requests/create_todo_request.dart';
import '../models/responses/todos_response.dart';
import '../models/responses/todo_stats_response.dart';

class HomeController extends Controller {
  final TodoController _todoController = TodoController();

  @override
  construct(BuildContext context) async {
    super.construct(context);
    testApi();
  }

  Future<void> testApi() async {
    print("🚀 Bắt đầu test API Todo...\n");

    try {
      // ✅ 1. Test getTodos
      print("1️⃣ Testing GET /todos...");
      final todosResponse = await _todoController.getTodos(page: 1, limit: 5);

      if (todosResponse != null) {
        print("📋 Danh sách todos: ${todosResponse.data.todos.length} items");

        if (todosResponse.data.todos.isNotEmpty) {
          print("   Pagination:");
          print("   - Current Page: ${todosResponse.data.pagination.currentPage}");
          print("   - Total Pages: ${todosResponse.data.pagination.totalPages}");
          print("   - Total Todos: ${todosResponse.data.pagination.totalTodos}");

          print("\n   📝 Sample Todos:");
          for (var todo in todosResponse.data.todos.take(3)) {
            print("   - ${todo.title}");
            print("     Status: ${todo.completed ? '✅ Completed' : '⏳ Pending'}");
            print("     Priority: ${todo.priority.name}");
            print("     Category: ${todo.category}");
          }
        }
      } else {
        print("❌ Không lấy được danh sách todos");
      }

      print("\n" + "="*50 + "\n");

      // ✅ 2. Test createTodo
      print("2️⃣ Testing POST /todos...");
      final newTodo = await _todoController.createToDo(
        CreateTodoRequest(
          title: "Test Task ${DateTime.now().millisecondsSinceEpoch}",
          description: "Todo tạo thử bằng Flutter Nylo",
          priority: "high",
          dueDate: DateTime.now().add(Duration(days: 7)),
          category: "Study",
        ),
      );

      if (newTodo != null) {
        print("🆕 Tạo mới todo thành công!");
        print("   ID: ${newTodo.id}");
        print("   Title: ${newTodo.title}");
        print("   Completed: ${newTodo.completed}");
        print("   Priority: ${newTodo.priority.name}");
        print("   Due Date: ${newTodo.dueDate}");
        print("   Category: ${newTodo.category}");
      } else {
        print("❌ Tạo todo thất bại");
      }

      print("\n" + "="*50 + "\n");

      // ✅ 3. Test toggle (nếu có todo vừa tạo)
      if (newTodo != null) {
        print("3️⃣ Testing PATCH /todos/{id}/toggle...");
        final toggled = await _todoController.toggleTodo(newTodo.id);

        if (toggled != null) {
          print("🔄 Toggle thành công!");
          print("   Status changed to: ${toggled.completed ? 'Completed ✅' : 'Pending ⏳'}");
        }
      }

      print("\n" + "="*50 + "\n");

      // ✅ 4. Test stats
      print("4️⃣ Testing GET /todos/stats/summary...");
      final stats = await _todoController.getTodoStats();

      if (stats != null) {
        print("📊 Thống kê:");
        print("   📝 Tổng số: ${stats.data.stats.total}");
        print("   ✅ Hoàn thành: ${stats.data.stats.completed}");
        print("   ⏳ Đang làm: ${stats.data.stats.pending}");
        print("   🔴 Quá hạn: ${stats.data.stats.overdue}");

        if (stats.data.stats.byPriority != null &&
            stats.data.stats.byPriority!.isNotEmpty) {
          print("\n   🎯 Theo độ ưu tiên:");
          stats.data.stats.byPriority!.forEach((key, value) {
            print("     $key: $value");
          });
        }

        if (stats.data.stats.byCategory != null &&
            stats.data.stats.byCategory!.isNotEmpty) {
          print("\n   📂 Theo danh mục:");
          stats.data.stats.byCategory!.forEach((key, value) {
            print("     $key: $value");
          });
        }
      } else {
        print("❌ Không lấy được thống kê");
      }

      print("\n" + "="*50);
      print("✅ Test API hoàn tất!\n");

    } catch (e, stackTrace) {
      print('❌ Lỗi test API: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<List<Todo>?> loadCompletedTodos() async {
    try {
      return await _todoController.getTodosByStatus(
        completed: true,
        limit: 50,
      );
    } catch (e) {
      print("❌ Lỗi load completed todos: $e");
      return null;
    }
  }

  Future<bool> createNewTodo({
    required String title,
    String? description,
    String? priority ,
    DateTime? dueDate,
    String? category,
    bool completed = false,
  }) async {
    try {
      // Validation
      if (title.trim().isEmpty) {
        print("❌ Title không được để trống");
        return false;
      }

      final result = await _todoController.createToDo(
        CreateTodoRequest(
          title: title.trim(),
          description: description?.trim(),
            priority: (priority ?? 'medium').toLowerCase(),
          dueDate: dueDate ?? DateTime.now().add(Duration(days: 1)),
          category: category ?? "General",
          completed: completed,
        ),
      );

      if (result != null) {
        print("✅ Tạo todo thành công: ${result.title}");
        return true;
      }

      return false;
    } catch (e) {
      print('❌ Lỗi tạo todo: $e');
      return false;
    }
  }

  Future<Todo?> toggleTodoStatus(String todoId) async {
    try {
      return await _todoController.toggleTodo(todoId);
    } catch (e) {
      print("❌ Lỗi toggle todo: $e");
      return null;
    }
  }

  /// Xóa todo
  Future<bool> removeTodo(String todoId) async {
    try {
      return await _todoController.deleteTodo(todoId);
    } catch (e) {
      print("❌ Lỗi xóa todo: $e");
      return false;
    }
  }

  Future<TodoStatsResponse?> getStats() async {
    try {
      return await _todoController.getTodoStats();
    } catch (e) {
      print("❌ Error load stats: $e");
      return null;
    }
  }

  Future<List<Todo>?> filterByPriority(Priority priority) async {
    try {
      return await _todoController.getTodosByPriority(
        priority: priority,
        limit: 50,
      );
    } catch (e) {
      print("❌ Lỗi filter by priority: $e");
      return null;
    }
  }

  /// Bulk delete todos


  String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
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

  /// Helper: Get priority color
  Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  IconData getCategoryIcon(String category) {
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

}
