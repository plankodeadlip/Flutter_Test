import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';
import '../models/todo.dart';
import '../networking/api_service.dart';
import '../models/responses/todos_response.dart';
import '../models/responses/todo_stats_response.dart';
import '../models/requests/create_todo_request.dart';
import '../models/requests/update_todo_request.dart';

class TodoController extends Controller {
  final ApiService _apiService = ApiService();

  Future<TodosResponse?> getTodos({
    int page = 1,
    int limit = 10,
    String? filter,   // 'all', 'pending', 'completed', ...
    String? sort,     // 'alphabet', 'recent', 'priority', 'category', ...
    String? search,
  }) async {
    try {
      final response = await _apiService.getAllTodos(page: page, limit: limit);

      if (response == null) {
        print("❌ API trả về null");
        return null;
      }

      // Xử lý response format linh hoạt
      Map<String, dynamic> jsonResponse;

      if (response is List) {
        // Nếu API trả về List trực tiếp
        jsonResponse = {
          'success': true,
          'data': {
            'todos': response,
            'pagination': {
              'currentPage': page,
              'totalPages': 1,
              'totalTodos': response.data.todos.length,
              'hasNextPage': false,
              'hasPrevPage': page > 1,
            }
          }
        };
      } else {
        // Nếu API trả về object
        jsonResponse = response as Map<String, dynamic>;
      }

      return TodosResponse.fromJson(jsonResponse);
    } catch (e) {
      print("❌ Lỗi getTodos: $e");
      return null;
    }
  }

  Future<TodosResponse?> getTodoById(String id) async {
    try {
      final response = await _apiService.getTodoById(id);

      if (response == null) return null;

      // Xử lý response có thể có nhiều format
      Map<String, dynamic> todoData;

      return response;
    } catch (e) {
      print("❌ Lỗi getTodoById: $e");
      return null;
    }
  }

  Future<Todo?> createToDo(CreateTodoRequest request) async {
    try {
      final response = await _apiService.createTodo(request.toJson());

      if (response == null) return null;

      // Xử lý response
      Map<String, dynamic> todoData;

      if (response['data'] != null && response['data']['todo'] != null) {
        todoData = response['data']['todo'];
      } else if (response['data'] != null) {
        todoData = response['data'];
      } else if (response['todo'] != null) {
        todoData = response['todo'];
      } else {
        todoData = response;
      }

      print("✅ Tạo todo thành công: ${todoData['id']}");
      return Todo.fromJson(todoData);
    } catch (e) {
      print("❌ Lỗi createToDo: $e");
      return null;
    }
  }

  Future<Todo?> updateTodo(String id, UpdateTodoRequest request) async {
    try {
      final response = await _apiService.updateTodo(
        id,
        request.toJson(),
      );

      if (response == null) return null;

      // Xử lý response
      Map<String, dynamic> todoData;

      if (response['data'] != null && response['data']['todo'] != null) {
        todoData = response['data']['todo'];
      } else if (response['data'] != null) {
        todoData = response['data'];
      } else if (response['todo'] != null) {
        todoData = response['todo'];
      } else {
        todoData = response;
      }

      print("✅ Cập nhật todo thành công: $id");
      return Todo.fromJson(todoData);
    } catch (e) {
      print("❌ Lỗi updateTodo: $e");
      return null;
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      final result = await _apiService.deleteTodo(id);
      if (result) {
        print("✅ Xóa todo thành công: $id");
      }
      return result;
    } catch (e) {
      print("❌ Lỗi deleteTodo: $e");
      return false;
    }
  }

  Future<Todo?> toggleTodo(String id) async {
    try {
      final response = await _apiService.toggleTodo(id);
      if (response == null) return null;

      // Chuẩn hóa data
      final todoData = response['data']?['todo'] ?? response['data'] ?? response['todo'] ?? response;

      final toggledTodo = Todo.fromJson(todoData);
      print("✅ Toggle todo thành công: ${toggledTodo.title} -> ${toggledTodo.completed ? 'Completed' : 'Pending'}");
      return toggledTodo;
    } catch (e) {
      print("❌ Lỗi toggleTodo: $e");
      return null;
    }
  }

  Future<TodoStatsResponse?> getTodoStats() async {
    try {
      final response = await _apiService.getTodoStats();

      if (response == null) return null;

      // Đảm bảo format đúng
      Map<String, dynamic> jsonResponse;

      if (response['data'] != null && response['data']['stats'] != null) {
        jsonResponse = {
          'success': true,
          'data': response['data']
        };
      } else if (response['stats'] != null) {
        jsonResponse = {
          'success': true,
          'data': {'stats': response['stats']}
        };
      } else {
        jsonResponse = {
          'success': true,
          'data': {'stats': response}
        };
      }

      return TodoStatsResponse.fromJson(jsonResponse);
    } catch (e) {
      print("❌ Lỗi getTodoStats: $e");
      return null;
    }
  }

  Future<List<Todo>?> getTodosByStatus({
    required bool completed,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await getTodos(page: page, limit: limit);
    if (response == null) return null;

    return response.data.todos
        .where((todo) => todo.completed == completed)
        .toList();
  }

  // ✅ Helper: Lọc todos theo priority
  Future<List<Todo>?> getTodosByPriority({
    required Priority priority,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await getTodos(page: page, limit: limit);
    if (response == null) return null;

    return response.data.todos
        .where((todo) => todo.priority == priority)
        .toList();
  }


}
