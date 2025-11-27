import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AuthApiService extends NyApiService {
  AuthApiService({BuildContext? buildContext})
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
  );

  get interceptor => {
    PrettyDioLogger: PrettyDioLogger(
      requestBody: false,
      requestHeader: false,
      responseBody: false,
    )
  };

  final String authEndPoint = "/auth";

  Future<Map<String, dynamic>?> login(Map<String, dynamic> data) async{
    final response = await network(
        request: (request) => request.post("$authEndPoint/login", data: data),
      handleSuccess: (response) {
          NyLogger.info("POST Login: ${response.statusCode}");
          return response.data;
      },
      handleFailure: (error) {
          NyLogger.error("POST Login error: ${_handleError(error)}");
          return null;
      },
    );

    if (response != null && response['data'] != null){
      final authData = response['data'];
      await saveAuthTokens(
        accessToken: authData['accessToken'],
        refreshToken: authData['refreshToKen'],
      );
    }
    return response;
  }
  
  Future<Map<String, dynamic>?> register(Map<String, dynamic> data) async {
    final response = await network(
        request: (request) => request.post("$authEndPoint/register", data: data),
        handleSuccess: (response) {
          NyLogger.info("POST Register: ${response.statusCode}");
          return response.data;
        },
      handleFailure: (error) {
          NyLogger.error("POST Register error: ${_handleError(error)}");
          return null;
      },
    );

    if (response != null && response['data'] != null){
      final auData = response['data'];
      await saveAuthTokens(
        accessToken:auData['accessToken'],
        refreshToken:auData['refreshToken'],
      );
    }
    return response;
  }

  Future<bool> logout() async{
    final result = await network(
        request: (request) => request.post("$authEndPoint/logout"),
      handleSuccess: (response) {
          NyLogger.info("POST logout: ${response.statusCode}");
          return true;
      },
      handleFailure:(error) {
          NyLogger.error("POST logout error: ${_handleError(error)}");
          return false;
      },
    );

    if (result) {
      await clearAuthData();
    }
    return result;
  }

  Future<Map<String, dynamic>?> refreshTokenAPI(String refreshToken) async{
    try {
      final dio = Dio(BaseOptions(baseUrl: getEnv("API_BASE_URL") ?? ""));
      final response = await dio.post("$authEndPoint/refresh-token", data: {'refreshToken': refreshToken});

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e){
      NyLogger.error("Refresh Token AI failed: $e");
    }
    return null;
  }

  static Future<void> saveAuthTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await NyStorage.save('auth_token', accessToken);
    if (refreshToken != null) {
      await NyStorage.save('refresh_token', refreshToken);
    }
    NyLogger.info('✅ Tokens saved successfully');
  }

  static Future<void> clearAuthData() async {
    await NyStorage.delete('auth_token');
    await NyStorage.delete('refresh_token');
    NyLogger.info('🗑️ Auth data cleared');
  }

  static Future<String?> getAccessToken() async {
    return await NyStorage.read<String>('auth_token');
  }

  static Future<String?> getRefreshToken() async {
    return await NyStorage.read<String>('refresh_token');
  }

  String _handleError(DioException e) {
    return e.response?.data?['message'] ?? e.message ?? 'Unknown error';
  }

  Future<Map<String, dynamic>?> getProfile() async {
    return await network(
      request: (request) => request.get("$authEndPoint/profile"),
      handleSuccess: (response) {
        return response.data;
      },
      handleFailure: (error) => null,
    );
  }

  Future<Map<String, dynamic>?> updateProfile(Map<String, dynamic> data) async {
    return await network(
      request: (request) => request.put("$authEndPoint/profile", data: data),
      handleSuccess: (response) => response.data,
      handleFailure: (error) => null,
    );
  }

  Future<Map<String, dynamic>?> changePassword(Map<String, dynamic> data) async {
    return await network(
      request: (request) => request.put("$authEndPoint/change-password", data: data),
      handleSuccess: (response) => response.data,
      handleFailure: (error) => null,
    );
  }
}
