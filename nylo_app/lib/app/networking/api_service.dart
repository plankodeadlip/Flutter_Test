import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/comment.dart';

/* ApiService
| -------------------------------------------------------------------------
| Define your API endpoints
| Learn more https://nylo.dev/docs/6.x/networking
|-------------------------------------------------------------------------- */

class ApiService extends NyApiService {
  ApiService({BuildContext? buildContext})
      : super(
    buildContext,
    decoders: modelDecoders,
    baseOptions: (BaseOptions baseOptions) {
      return baseOptions
        ..baseUrl = dotenv.env['API_BASE_URL'] ?? "https://fallback.com"
        ..connectTimeout = const Duration(seconds: 10)
        ..sendTimeout = const Duration(seconds: 10)
        ..receiveTimeout = const Duration(seconds: 10)
        ..headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
        };
    },
  );

  final Dio _client = Dio(BaseOptions(
    baseUrl: const String.fromEnvironment('BASE_URL', defaultValue: 'https://yourapi.mockapi.io/'),
  ));

  Dio get dio => _client;

  @override
  get interceptors => {
    PrettyDioLogger: PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
    ),
    RetryInterceptor: RetryInterceptor(
      dio: dio,
      retries: 3,
      retryDelay: const Duration(seconds: 2),
    ),
  };

  final String commentsEndpoint = "/comments";
  final String postsEndpoint = "/posts";

  Future<dynamic> getRequest({
    int page = 1,
    int limit = 100,
    Function(dynamic data)? onSuccess,
    Function(String message)? onFailure,
  }) async {
    return await network(
      request: (request) =>
          request.get("$postsEndpoint?page=$page&limit=$limit"),
      handleSuccess: (Response response) {
        NyLogger.info("API success: ${response.statusCode}");
        onSuccess?.call(response.data);
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("API error: ${error.message}");
        onFailure?.call(error.message ?? "Lỗi không xác định");
        return null;
      },
    );
  }

  Future<dynamic> postRequest(Map<String, dynamic> data) async {
    return await network(
      request: (request) => request.post(postsEndpoint, data: data),
      handleSuccess: (Response response) {
        NyLogger.info("POST success: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("POST error: ${error.message}");
        return null;
      },
    );
  }

  Future<dynamic> putRequest(int id, Map<String, dynamic> data) async {
    return await network(
      request: (request) => request.put("$postsEndpoint/$id", data: data),
      handleSuccess: (Response response) {
        NyLogger.info("PUT success: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("PUT error: ${error.message}");
        return null;
      },
    );
  }

  Future<dynamic> deleteRequest(int id) async {
    return await network(
      request: (request) => request.delete("$postsEndpoint/$id"),
      handleSuccess: (Response response) {
        NyLogger.info("DELETE success: ${response.statusCode}");
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("DELETE error: ${error.message}");
        return null;
      },
    );
  }

  Future<List<dynamic>> getComments({
    required int postId,
    Function(List<dynamic> data)? onSuccess,
    Function(String message)? onFailure,
  }) async {
    return await network(
      request: (request) => request.get("$commentsEndpoint?postId=$postId"),
      handleSuccess: (Response response) {
        NyLogger.info("GET Comments success: ${response.statusCode}");
        if (response.data is List) {
          onSuccess?.call(response.data);
          return response.data;
        }
        return [];
      },
      handleFailure: (error) {
        if (error.response?.statusCode == 404) {
          NyLogger.info("No comments for postId=$postId (404 Not Found)");
          return [];
        }
        NyLogger.error("GET Comments error: ${error.message}");
        onFailure?.call(error.message ?? "Lỗi không xác định");
        return [];
      },
    );
  }

}

/* RetryInterceptor
| -------------------------------------------------------------------------
| Custom logic to retry failed requests
|-------------------------------------------------------------------------- */
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final Duration retryDelay;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Chỉ retry nếu là lỗi mạng hoặc timeout
    if (_shouldRetry(err) && retries > 0) {
      for (int attempt = 1; attempt <= retries; attempt++) {
        NyLogger.info("🔁 Retry attempt $attempt/${retries} ...");
        await Future.delayed(retryDelay);
        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          if (attempt == retries) {
            return handler.next(err); // hết số lần retry
          }
        }
      }
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;
  }
}
