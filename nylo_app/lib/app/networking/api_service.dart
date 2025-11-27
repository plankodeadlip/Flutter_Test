import 'dart:io';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/post.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:dio/dio.dart';

class ApiService extends NyApiService {
  ApiService({BuildContext? buildContext})
      : super(
    buildContext,
    decoders: modelDecoders,
    initDio: (api) {
      (api.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
          () {
        HttpClient client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      return api;
    },
    baseOptions: (BaseOptions baseOptions) {
      return baseOptions
        ..baseUrl = getEnv("API_BASE_URL") ?? "https://fallback.com"
        ..connectTimeout = const Duration(seconds: 10)
        ..sendTimeout = const Duration(seconds: 10)
        ..receiveTimeout = const Duration(seconds: 10)
        ..headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
        };
    },
  );

  @override
  get interceptors => {
    PrettyDioLogger: PrettyDioLogger(
      requestHeader: false,
      requestBody: false,
      responseBody: false,
    ),
  };

  final String commentsEndpoint = "/comments";
  final String postsEndpoint = "/posts";

  Future<List<dynamic>?> getRequest({
    int page = 1,
    int limit = 10,
  }) async {
    return await network(
      retry: 3,
      retryDelay: Duration(seconds: 2),
      request: (request) =>
          request.get("$postsEndpoint?page=$page&limit=$limit"),
      handleSuccess: (Response response) {
        NyLogger.info("✅ GET Posts: Page $page, Limit $limit - ${response.statusCode}");
        if (response.data is List) {
          NyLogger.info("📦 Received ${(response.data as List).length} posts");
        }
        return response.data;
      },
      handleFailure: (error) {
        NyLogger.error("❌ GET Posts error (page $page): ${error.message}");
        return null;
      },
    );
  }

  Future<Map<String, dynamic>?> postRequest(Map<String, dynamic> data) async {
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

  Future<Map<String, dynamic>?> putRequest(
      int id, Map<String, dynamic> data) async {
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

  Future<Map<String, dynamic>?> deleteRequest(int id) async {
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

  /// Optimized: Get comments filtered by postId using query parameter
  Future<List<dynamic>> getComments({
    required int postId,
    Function(List<dynamic> data)? onSuccess,
    Function(String message)? onFailure,
  }) async {
    return await network(
      retry: 2, // Add retry for reliability
      retryDelay: Duration(milliseconds: 500),
      // Use query parameter for server-side filtering (if your API supports it)
      request: (request) => request.get("$commentsEndpoint?postId=$postId"),
      handleSuccess: (Response response) {
        if (response.data is! List) {
          NyLogger.info("⚠️ Unexpected response format for comments");
          return [];
        }

        // Server-side filtering is preferred, but add client-side as fallback
        final filtered = (response.data as List)
            .where((comment) {
          if (comment['postId'] == null) return false;
          final commentPostId = int.tryParse(comment['postId'].toString());
          return commentPostId == postId;
        })
            .toList();

        NyLogger.info("✅ Retrieved ${filtered.length} comments for post $postId");
        onSuccess?.call(filtered);
        return filtered;
      },
      handleFailure: (error) {
        final errorMsg = error.message ?? "Unknown error";
        NyLogger.error("❌ GET Comments error for post $postId: $errorMsg");
        onFailure?.call(errorMsg);
        return [];
      },
    );
  }

  /// Get all comments at once (useful for bulk operations)
  Future<List<dynamic>> getAllComments() async {
    return await network(
      retry: 2,
      retryDelay: Duration(milliseconds: 500),
      request: (request) => request.get(commentsEndpoint),
      handleSuccess: (Response response) {
        if (response.data is List) {
          NyLogger.info("✅ Retrieved ${response.data.length} total comments");
          return response.data;
        }
        NyLogger.info("⚠️ Unexpected response format");
        return [];
      },
      handleFailure: (error) {
        NyLogger.error("❌ GET ALL Comments error: ${error.message}");
        return [];
      },
    );
  }

  Future<List<Post>> searchPostsByAPI(String query, int page, int limit) async {
    if (query.trim().isEmpty) {
      return [];
    }
    try {
      final url = "$postsEndpoint?page=$page&limit=$limit&filter=$query";
      final response = await network(
        request: (request) => request.get(url),
        handleSuccess: (res) async {
          if (res.data is! List) return [];

          return (res.data as List)
              .map<Post>((json) => Post.fromJson(json))
              .toList();
        },
        handleFailure: (error) {
          NyLogger.error("❌ Search API error: ${error.message}");
          return [];
        },
      );

      return response;
    } catch (e) {
      NyLogger.error("❌ Search exception: $e");
      return [];
    }
  }
}