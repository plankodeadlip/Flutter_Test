import '/app/networking/auth_api_service.dart';
import '/app/controllers/auth_controller.dart';
import '/app/controllers/user_controller.dart';
import '/app/controllers/todo_controller.dart';
import '/app/controllers/home_controller.dart';

import '../app/models/responses/success_response.dart';
import '../app/models/responses/error_response.dart';
import '../app/models/responses/todo_stats_response.dart';
import '../app/models/responses/todos_response.dart';
import '../app/models/requests/update_todo_request.dart';
import '../app/models/requests/create_todo_request.dart';
import '../app/models/responses/auth_response.dart';
import '../app/models/requests/login_request.dart';
import '../app/models/requests/register_request.dart';
import '/app/models/todo.dart';
import '/app/models/user.dart';

import '/app/networking/api_service.dart';

/* Model Decoders */
final Map<Type, dynamic> modelDecoders = {
  // Basic Map
  Map<String, dynamic>: (data) => Map<String, dynamic>.from(data),

  // Users
  List<User>: (data) => List.from(data).map((json) => User.fromJson(json)).toList(),
  User: (data) => User.fromJson(data),

  // Todos
  List<Todo>: (data) => List.from(data).map((json) => Todo.fromJson(json)).toList(),
  Todo: (data) => Todo.fromJson(data),

  // Register / Login Requests
  List<RegisterRequest>: (data) => List.from(data).map((json) => RegisterRequest.fromJson(json)).toList(),
  RegisterRequest: (data) => RegisterRequest.fromJson(data),

  List<LoginRequest>: (data) => List.from(data).map((json) => LoginRequest.fromJson(json)).toList(),
  LoginRequest: (data) => LoginRequest.fromJson(data),

  // AuthResponse
  List<AuthResponse>: (data) => List.from(data).map((json) => AuthResponse.fromJson(json)).toList(),
  AuthResponse: (data) => AuthResponse.fromJson(data),

  // Create / Update Todo Requests
  List<CreateTodoRequest>: (data) => List.from(data).map((json) => CreateTodoRequest.fromJson(json)).toList(),
  CreateTodoRequest: (data) => CreateTodoRequest.fromJson(data),

  List<UpdateTodoRequest>: (data) => List.from(data).map((json) => UpdateTodoRequest.fromJson(json)).toList(),
  UpdateTodoRequest: (data) => UpdateTodoRequest.fromJson(data),

  // TodosResponse / StatsResponse
  List<TodosResponse>: (data) => List.from(data).map((json) => TodosResponse.fromJson(json)).toList(),
  TodosResponse: (data) => TodosResponse.fromJson(data),

  List<TodoStatsResponse>: (data) => List.from(data).map((json) => TodoStatsResponse.fromJson(json)).toList(),
  TodoStatsResponse: (data) => TodoStatsResponse.fromJson(data),

  // ErrorResponse
  List<ErrorResponse>: (data) => List.from(data).map((json) => ErrorResponse.fromJson(json)).toList(),
  ErrorResponse: (data) => ErrorResponse.fromJson(data),

  // ===================== SuccessResponse<T> =====================
  // Nếu SuccessResponse<User>
  SuccessResponse<User>: (data) => SuccessResponse<User>.fromJson(
    data,
        (json) => User.fromJson(json as Map<String, dynamic>),
  ),
  // Nếu SuccessResponse<Todo>
  SuccessResponse<Todo>: (data) => SuccessResponse<Todo>.fromJson(
    data,
        (json) => Todo.fromJson(json as Map<String, dynamic>),
  ),
  // Nếu SuccessResponse<Map<String,dynamic>> hoặc generic khác
  SuccessResponse<Map<String, dynamic>>: (data) => SuccessResponse<Map<String, dynamic>>.fromJson(
    data,
        (json) => Map<String, dynamic>.from(json as Map),
  ),

};

/* API Decoders */
final Map<Type, dynamic> apiDecoders = {
  ApiService: () => ApiService(),

  AuthApiService: AuthApiService(),
};

/* Controller Decoders */
final Map<Type, dynamic> controllers = {
  HomeController: () => HomeController(),
  TodoController: () => TodoController(),
  UserController: () => UserController(),
  AuthController: () => AuthController(),
};
