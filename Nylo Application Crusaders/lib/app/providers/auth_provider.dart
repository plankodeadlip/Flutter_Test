import 'package:flutter/material.dart';
import '../networking/auth_api_service.dart';
import '/app/models/user.dart';
import '../models/responses/auth_response.dart';
import '/app/controllers/auth_controller.dart';
import '../models/requests/login_request.dart';
import '../models/requests/register_request.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  final AuthController _authController = AuthController();
  final AuthApiService _authApiService = AuthApiService();

  //Getter
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    initializeAuth();
  }


  // Khởi tạo - Kiểm tra session đã lưu
  Future<void> initializeAuth() async {
    try {
      await _checkExistingAuth();
    } catch (e) {
      NyLogger.error('❌ Initialize auth error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkExistingAuth() async {
    try {
      final token = await AuthApiService.getAccessToken();
      if (token != null) {
        final authService = AuthApiService();
        final response = await authService.getProfile();

        if (response != null && response['data'] != null) {
          _currentUser = User.fromJson(response['data']);
          _isAuthenticated = true;
          NyLogger.info('✅ Existing session found');
        } else {
          await AuthApiService.clearAuthData();
        }
      }
    } catch (e) {
      NyLogger.error('❌ Check auth error: $e');
      await AuthApiService.clearAuthData();
    }
  }

  Future<bool> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String passwordagain, // Giữ param này nếu API cần, hoặc chỉ để validate UI
  }) async {
    _setLoading(true);

    try {
      // 1. Chuẩn bị data gửi lên
      final requestBody = {
        "email": email,
        "username": username,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
      };

      // 2. Gọi API Service
      final response = await _authApiService.register(requestBody);

      // 3. Xử lý Logic Response (Phần bạn yêu cầu chuyển vào đây)
      if (response != null && response['data'] != null) {
        final authData = response['data'];

        // ✅ Lưu Token bằng Helper từ AuthApiService
        await AuthApiService.saveAuthTokens(
          accessToken: authData['accessToken'],
          refreshToken: authData['refreshToken'], // Key thường là 'refreshToken' (chữ thường)
        );

        // ✅ Parse User Data (Giả sử API trả về object 'user' trong 'data')
        if (authData['user'] != null) {
          _currentUser = User.fromJson(authData['user']);
        }

        _isAuthenticated = true;
        _errorMessage = null;

        NyLogger.info('✅ Đăng ký thành công: ${_currentUser?.username}');
        _setLoading(false);
        return true;
      } else {
        // Xử lý trường hợp API trả về lỗi nhưng format không khớp
        _errorMessage = response?['message'] ?? "Đăng ký thất bại. Vui lòng thử lại.";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = "Lỗi hệ thống: $e";
      NyLogger.error(_errorMessage!);
      _setLoading(false);
      return false;
    }
  }

  // ==========================================
  // 🔵 LOGIN LOGIC
  // ==========================================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      // 1. Chuẩn bị data
      final requestBody = {
        "email": email,
        "password": password,
      };

      // 2. Gọi API
      final response = await _authApiService.login(requestBody);

      // 3. Xử lý Logic Response
      if (response != null && response['data'] != null) {
        final authData = response['data'];

        // ✅ Lưu Token
        await AuthApiService.saveAuthTokens(
          accessToken: authData['accessToken'],
          refreshToken: authData['refreshToken'],
        );

        // ✅ Parse User
        if (authData['user'] != null) {
          _currentUser = User.fromJson(authData['user']);
        }

        _isAuthenticated = true;
        _errorMessage = null;

        NyLogger.info('✅ Đăng nhập thành công: ${_currentUser?.username}');
        _setLoading(false);
        return true;
      } else {
        // Lấy message lỗi từ API nếu có
        _errorMessage = response?['message'] ?? "Email hoặc mật khẩu không đúng";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = "Lỗi kết nối: $e";
      NyLogger.error(_errorMessage!);
      _setLoading(false);
      return false;
    }
  }

  // ==========================================
  // 🟠 LOGOUT LOGIC
  // ==========================================
  Future<void> logout() async {
    await _authApiService.logout(); // Gọi API logout (nếu cần)
    await AuthApiService.clearAuthData(); // Xóa token local

    _currentUser = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Helper để update loading và notify UI
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    if(!_isAuthenticated) return;

    try{
      final user = await _authController.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    }catch(e) {
      print('Lỗi refresh user data: $e');
    }
  }

  Future<void> _saveToken(String token) async{
    try{
      await NyStorage.save('auth_token', token); // ✅ Save the actual token!
      print('✅ Token saved successfully');
    } catch(e){
      print('❌ Error saving token: $e');
      rethrow;
    }
  }

  Future<void> _clearAuthData() async {
    try {
      await NyStorage.delete('auth_token');
      print('✅ Token đã được xóa');
    } catch (e) {
      print("❌ Lỗi xóa token: $e");
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
