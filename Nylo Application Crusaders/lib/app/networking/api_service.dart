import 'dart:io';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/responses/todos_response.dart';
import '../utils/enum.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'auth_api_service.dart';

class ApiService extends NyApiService {
  ApiService({BuildContext? buildContext})
    : super(
        buildContext,
        decoders: modelDecoders,
        baseOptions: (BaseOptions baseOptions) {
          return baseOptions
            ..baseUrl = getEnv("API_BASE_URL") ?? "https://fallback.com"
            ..connectTimeout = Duration(seconds: 10)
            ..sendTimeout = Duration(seconds: 10)
            ..receiveTimeout = Duration(seconds: 10)
            ..headers = {
              "Content-Type": "application/json",
              "Accept": "application/json",
            };
        },
        initDio: (api) {
          // SSL Certificate bypass (chỉ development)
          (api.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
            HttpClient client = HttpClient();
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };

          // ✅ THÊM INTERCEPTOR ĐỂ TỰ ĐỘNG GỬI TOKEN
          api.interceptors.add(
            InterceptorsWrapper(
              onError: (DioException error, handler) async {
                // Xử lý lỗi 401 - Token expired
                if (error.response?.statusCode == 401) {
                  NyLogger.info('⚠️ Token expired, attempting refresh...');

                  final refreshToken = await AuthApiService.getRefreshToken();

                  if (refreshToken != null) {
                    try {
                      // Gọi API refresh token (dùng hàm helper static hoặc gọi trực tiếp)
                      // Lưu ý: Không dùng 'api' instance hiện tại để tránh loop, dùng AuthApiService
                      final authService = AuthApiService();
                      final refreshResponse = await authService.refreshTokenAPI(
                        refreshToken,
                      );

                      if (refreshResponse != null &&
                          refreshResponse['data'] != null) {
                        final newAccessToken =
                            refreshResponse['data']['accessToken'];
                        final newRefreshToken =
                            refreshResponse['data']['refreshToken']; // Nếu có

                        // Lưu token mới
                        await AuthApiService.saveAuthTokens(
                          accessToken: newAccessToken,
                          refreshToken: newRefreshToken ?? refreshToken,
                        );

                        // Retry request với token mới
                        error.requestOptions.headers['Authorization'] =
                            'Bearer $newAccessToken';

                        // Tạo một instance Dio mới để retry (tránh dùng lại interceptor cũ gây lỗi stack)
                        // Hoặc dùng api.fetch nhưng cẩn thận loop
                        final response = await api.fetch(error.requestOptions);
                        return handler.resolve(response);
                      }
                    } catch (e) {
                      NyLogger.error('❌ Refresh token failed: $e');
                    }
                  }

                  // Nếu refresh thất bại, xóa token
                  await AuthApiService.clearAuthData();
                  NyLogger.error('❌ Authentication failed, please login again');
                }
                return handler.next(error);
              },
            ),
          );

          return api;
        },
      );

  // ============================================
  // ✅ AUTH HEADER SETUP (NYLO STANDARD)
  // ============================================
  @override
  Future<RequestHeaders> setAuthHeaders(RequestHeaders headers) async {
    // Đọc token từ storage
    String? myAuthToken = await AuthApiService.getAccessToken();

    if (myAuthToken != null) {
      // Nylo helper method để add Bearer token
      headers.addBearerToken(myAuthToken);
      // NyLogger.debug('🔑 Token injected via setAuthHeaders');
    }

    return headers;
  }

  // ============================================
  // 📍 ENDPOINTS
  // ============================================
  @override
  get interceptors => {
    PrettyDioLogger: PrettyDioLogger(
      requestHeader: false,
      requestBody: false,
      responseBody: false,
    ),
  };

  final String toDoEndpoints = "/todos";
  final String healthEndpoint = "/health";

  // ============================================
  // 🔧 HELPER METHOD - Error Handling
  // ============================================

  String _handleError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? e.response?.statusMessage;

      switch (statusCode) {
        case 400:
          return 'Dữ liệu không hợp lệ: $message';
        case 401:
          return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại';
        case 403:
          return 'Bạn không có quyền truy cập';
        case 404:
          return 'Không tìm thấy dữ liệu';
        case 422:
          return 'Dữ liệu không hợp lệ: $message';
        case 500:
          return 'Lỗi server. Vui lòng thử lại sau';
        default:
          return 'Lỗi: $statusCode - $message';
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Kết nối quá lâu. Vui lòng kiểm tra mạng';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Không nhận được phản hồi từ server';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Không thể kết nối đến server. Kiểm tra mạng';
    } else {
      return 'Lỗi kết nối: ${e.message}';
    }
  }

  // ============================================
  // 📋 TODOS ENDPOINTS
  // ============================================

  Future<TodosResponse?> getAllTodos({int page = 1, int limit = 10}) {
    return getFilteredTodos(page: page, limit: limit);
  }

  Future<int> getTodosCount() async {
    try {
      final response = await network<int>(
        request: (request) => request.get(
          toDoEndpoints,
          queryParameters: {
            'page': 1,
            'limit': 1,
          }, // lấy ít nhất, không cần nhiều
        ),
        handleSuccess: (res) {
          try {
            final data = TodosResponse.fromJson(res.data);
            return data.data.pagination.totalTodos; // Lấy tổng số lượng
          } catch (e) {
            NyLogger.error("❌ Parse error: $e");
            return 0;
          }
        },
        handleFailure: (error) {
          NyLogger.error("❌ GET Todos count error: ${_handleError(error)}");
          return 0;
        },
      );

      return response ?? 0;
    } catch (e) {
      NyLogger.error("❌ Exception count: $e");
      return 0;
    }
  }

  // Trong api_service.dart
  Future<int> getCompletedTodosCount() async {
    try {
      final response = await network<int>(
        request: (request) => request.get(
          toDoEndpoints,
          queryParameters: {
            'page': 1,
            'limit': 1,
            'completed': true, // ✅ Chỉ lấy todos đã hoàn thành
          },
        ),
        handleSuccess: (res) {
          try {
            final data = TodosResponse.fromJson(res.data);
            return data.data.pagination.totalTodos; // Tổng số todos completed
          } catch (e) {
            NyLogger.error("❌ Parse error: $e");
            return 0;
          }
        },
        handleFailure: (error) {
          NyLogger.error("❌ GET Completed count error: ${_handleError(error)}");
          return 0;
        },
      );

      return response ?? 0;
    } catch (e) {
      NyLogger.error("❌ Exception completed count: $e");
      return 0;
    }
  }

  Future<TodosResponse?> getTodoById(String id) async {
    return await network(
      request: (request) => request.get("$toDoEndpoints/$id"),
      handleSuccess: (response) {
        NyLogger.info("✅ GET Todo #$id: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("❌ GET Todo #$id error: ${_handleError(error)}");
        return null;
      },
    );
  }

  // ============================================
  // 📋 IMPROVED TODOS ENDPOINTS
  // ============================================

  /// Lấy danh sách todos với filter đầy đủ
  Future<TodosResponse?> getFilteredTodos({
    int page = 1,
    int limit = 10,
    String? searchQuery,
    String? status, // "all", "pending", "completed"
    String? filterMode, // "overdue", "alphabet", "recent", "priority", "category"
    TodoPriority? priority,
    String? category,
  }) async {
    try {
      // ✅ Tạo TodoFilterParams để quản lý params tốt hơn
      TodoSortBy? sortBy;
      SortOrder? sortOrder;

      // Map filterMode sang sortBy/sortOrder
      if (filterMode != null && filterMode != 'all') {
        switch (filterMode) {
          case 'alphabet':
            sortBy = TodoSortBy.title;
            sortOrder = SortOrder.asc;
            break;
          case 'recent':
            sortBy = TodoSortBy.createdAt;
            sortOrder = SortOrder.desc;
            break;
          case 'priority':
            sortBy = TodoSortBy.priority;
            sortOrder = SortOrder.desc;
            break;
          case 'category':
            sortBy = TodoSortBy.title; // hoặc category nếu backend hỗ trợ
            sortOrder = SortOrder.asc;
            break;
          case 'dueDate':
            sortBy = TodoSortBy.dueDate;
            sortOrder = SortOrder.asc;
            break;
        }
      }

      // Xử lý completed status
      bool? completed;
      if (status != null && status != 'all') {
        completed = status == 'completed';
        print('🔄 Status "$status" -> completed: $completed');
      }

      // ✅ Dùng TodoFilterParams
      final filterParams = TodoFilterParams(
        page: page,
        limit: limit,
        search: searchQuery,
        priority: priority,
        completed: completed,
        category: category,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      final params = filterParams.toQueryParams();

      // ✅ Xử lý đặc biệt cho filterMode như "overdue"
      if (filterMode == 'overdue') {
        params['completed'] = false;
        params['dueDateBefore'] = DateTime.now().toIso8601String();
      }

      NyLogger.debug("📤 Filter params: $params");

      final response = await network(
        request: (request) =>
            request.get(toDoEndpoints, queryParameters: params),
        handleSuccess: (res) {
          try {
            NyLogger.debug("📥 Response status: ${res.statusCode}");
            if (res.data is Map && res.data['data'] != null) {
              final todosResponse = TodosResponse.fromJson(res.data);
              NyLogger.info(
                "✅ Loaded ${todosResponse.data.todos.length} todos",
              );
              return todosResponse;
            }
          } catch (e) {
            NyLogger.error("❌ Parse error: $e");
          }
          return null;
        },
        handleFailure: (err) {
          NyLogger.error("❌ GET Filtered Todos error: ${_handleError(err)}");
          return null;
        },
      );

      return response;
    } catch (e) {
      NyLogger.error("❌ Exception getFilteredTodos: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> createTodo(Map<String, dynamic> data) async {
    return await network(
      request: (request) => request.post(toDoEndpoints, data: data),
      handleSuccess: (response) {
        NyLogger.info("✅ POST Todo: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("❌ POST Todo error: ${_handleError(error)}");
        return null;
      },
    );
  }

  Future<Map<String, dynamic>?> updateTodo(
    String id,
    Map<String, dynamic> data,
  ) async {
    return await network(
      request: (request) => request.put("$toDoEndpoints/$id", data: data),
      handleSuccess: (response) {
        NyLogger.info("✅ PUT Todo #$id: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("❌ PUT Todo #$id error: ${_handleError(error)}");
        return null;
      },
    );
  }

  Future<bool> deleteTodo(String id) async {
    try {
      final result = await network(
        request: (request) => request.delete("$toDoEndpoints/$id"),
        handleSuccess: (response) {
          NyLogger.info("✅ DELETE Todo #$id: ${response.statusCode}");
          return true;
        },
        handleFailure: (error) {
          NyLogger.error("❌ DELETE Todo #$id error: ${_handleError(error)}");
          return false;
        },
      );
      if (result) {
        print("✅ Xóa todo thành công: $id");
      }
      return result;
    } catch (e) {
      print("❌ Lỗi deleteTodo: $e");
      return false;
    }
  }

  /// PATCH /todos/{id}/toggle - Toggle trạng thái hoàn thành
  Future<Map<String, dynamic>?> toggleTodo(String id) async {
    return await network(
      request: (request) => request.patch("$toDoEndpoints/$id/toggle"),
      handleSuccess: (response) {
        NyLogger.info("✅ PATCH Toggle Todo #$id: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error(
          "❌ PATCH Toggle Todo #$id error: ${_handleError(error)}",
        );
        return null;
      },
    );
  }

  /// GET /todos/stats/summary - Lấy thống kê todos
  Future<Map<String, dynamic>?> getTodoStats() async {
    return await network(
      request: (request) => request.get("$toDoEndpoints/stats/summary"),
      handleSuccess: (response) {
        NyLogger.info("✅ GET Todo Stats: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("❌ GET Todo Stats error: ${_handleError(error)}");
        return null;
      },
    );
  }
  // ============================================
  // ❤️ HEALTH CHECK
  // ============================================

  /// GET /health - Kiểm tra server status
  Future<Map<String, dynamic>?> healthCheck() async {
    return await network(
      request: (request) => request.get(healthEndpoint),
      handleSuccess: (response) {
        NyLogger.info("✅ GET Health Check: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("❌ GET Health Check error: ${_handleError(error)}");
        return null;
      },
    );
  }

  //===================================
  // Search
  //===================================
  /// GET /todos?search=query&page=1&limit=10 - Tìm kiếm todos
  Future<TodosResponse?> searchTodos({
    int page = 1,
    int limit = 10,
    required String query,
  }) async {
    if (query.trim().isEmpty) {
      return null;
    }

    try {
      return await network(
        retry: 2,
        retryDelay: Duration(seconds: 1),
        request: (request) => request.get(
          toDoEndpoints,
          queryParameters: {'search': query, 'page': page, 'limit': limit},
        ),
        handleSuccess: (res) {
          try {
            return TodosResponse.fromJson(res.data);
          } catch (e) {
            NyLogger.error("❌ Parse error: $e");
            return null;
          }
        },
        handleFailure: (error) {
          NyLogger.error("❌ Search error: ${_handleError(error)}");
          return [];
        },
      );
    } catch (e) {
      NyLogger.error("❌ Search exception: $e");
      return null;
    }
  }
}

// ==================== FILTER PARAMS CLASS ====================
class TodoFilterParams {
  final int page;
  final int limit;
  final String? search;
  final TodoPriority? priority;
  final bool? completed;
  final String? category;
  final TodoSortBy? sortBy;
  final SortOrder? sortOrder;

  TodoFilterParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.priority,
    this.completed,
    this.category,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{'page': page, 'limit': limit};

    if (search != null && search!.trim().isNotEmpty) {
      params['search'] = search!.trim();
    }

    if (priority != null) {
      params['priority'] = priority!.value;
    }

    if (completed != null) {
      params['completed'] = completed;
    }

    if (category != null && category!.trim().isNotEmpty) {
      params['category'] = category!.trim();
    }

    if (sortBy != null) {
      params['sortBy'] = sortBy!.value;
    }

    if (sortOrder != null) {
      params['sortOrder'] = sortOrder!.value;
    }

    return params;
  }
}

