import '../networking/auth_api_service.dart';
import '/app/controllers/controller.dart';
import '../models/responses/auth_response.dart';
import '../models/requests/login_request.dart';
import '../models/requests/register_request.dart';
import '/app/models/user.dart';

class AuthController extends Controller {
  final AuthApiService _apiService = AuthApiService();

  // 🟢 Đăng ký tài khoản
  Future<AuthResponse?> register(RegisterRequest request) async {
    try {
      final response = await _apiService.register(request.toJson());

      if (response == null) {
        print("❌ Register failed: API returned null");
        return null;
      }

      print('✅ Register response received');
      return AuthResponse.fromJson(response);
    } catch (e) {
      print("❌ Lỗi khi đăng ký: $e");
      return null;
    }
  }

  Future<AuthResponse?> login(LoginRequest request) async {
    try {
      final response = await _apiService.login(request.toJson());

      if (response == null) {
        print("❌ Login failed: API returned null");
        return null;
      }

      print('✅ Login successful');
      return AuthResponse.fromJson(response);
    } catch (e) {
      print("❌ Lỗi khi đăng nhập: $e");
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _apiService.getProfile();

      if (response == null) {
        print("❌ Get profile failed: API returned null");
        return null;
      }

      // Xử lý nhiều format response
      Map<String, dynamic> userData;

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        if (data['user'] != null) {
          print('✅ User data received (nested format)');
          userData = data['user'];
        } else {
          print('✅ User data received (direct format)');
          userData = data;
        }
      } else if (response['user'] != null) {
        userData = response['user'];
      } else {
        userData = response;
      }

      return User.fromJson(userData);
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin user: $e");
      return null;
    }
  }

  // ✅ CẬP NHẬT PROFILE
  Future<User?> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (username != null) data['username'] = username;
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (email != null) data['email'] = email;

      final response = await _apiService.updateProfile(data);

      if (response == null) {
        print("❌ Update profile failed");
        return null;
      }

      // Xử lý response
      Map<String, dynamic> userData;

      if (response['data'] != null && response['data']['user'] != null) {
        userData = response['data']['user'];
      } else if (response['data'] != null) {
        userData = response['data'];
      } else if (response['user'] != null) {
        userData = response['user'];
      } else {
        userData = response;
      }

      print('✅ Profile updated successfully');
      return User.fromJson(userData);
    } catch (e) {
      print("❌ Lỗi khi cập nhật profile: $e");
      return null;
    }
  }

  // ✅ ĐỔI MẬT KHẨU
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      // Validation
      if (newPassword != confirmPassword) {
        print("❌ Mật khẩu mới không khớp");
        return false;
      }

      if (newPassword.length < 6) {
        print("❌ Mật khẩu phải có ít nhất 6 ký tự");
        return false;
      }

      final response = await _apiService.changePassword({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });

      if (response == null) {
        print("❌ Change password failed");
        return false;
      }

      final success = response['success'] == true;

      if (success) {
        print('✅ Đổi mật khẩu thành công');
      } else {
        print('❌ Đổi mật khẩu thất bại: ${response['message']}');
      }

      return success;
    } catch (e) {
      print("❌ Lỗi khi đổi mật khẩu: $e");
      return false;
    }
  }

  // ✅ ĐĂNG XUẤT
  Future<bool> logout() async {
    try {
      final result = await _apiService.logout();

      if (result) {
        print('✅ Logout successful');
      }

      return result;
    } catch (e) {
      print("❌ Lỗi khi đăng xuất: $e");
      return false;
    }
  }
  // ✅ REFRESH TOKEN
  Future<AuthResponse?> refreshToken(String refreshToken) async {
    try {
      final response = await _apiService.refreshTokenAPI(refreshToken);

      if (response == null) {
        print("❌ Refresh token failed");
        return null;
      }

      print('✅ Token refreshed successfully');
      return AuthResponse.fromJson(response);
    } catch (e) {
      print("❌ Lỗi khi refresh token: $e");
      return null;
    }
  }

  // ✅ Helper: Validate email format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // ✅ Helper: Validate password strength
  bool isStrongPassword(String password) {
    // Ít nhất 8 ký tự, có chữ hoa, chữ thường và số
    if (password.length < 8) return false;

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));

    return hasUppercase && hasLowercase && hasDigits;
  }

  String getPasswordStrengthMessage(String password) {
    if (password.length < 6) {
      return 'Mật khẩu quá ngắn (tối thiểu 6 ký tự)';
    } else if (password.length < 8) {
      return 'Mật khẩu yếu';
    } else if (isStrongPassword(password)) {
      return 'Mật khẩu mạnh';
    } else {
      return 'Mật khẩu trung bình';
    }
  }
} 
