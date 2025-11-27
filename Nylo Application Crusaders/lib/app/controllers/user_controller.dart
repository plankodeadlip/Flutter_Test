import 'package:flutter_app/app/networking/auth_api_service.dart';

import '../models/responses/success_response.dart';
import '/app/controllers/controller.dart';
import '../models/user.dart';
import '../networking/api_service.dart';

class UserController extends Controller {
  final AuthApiService _apiService = AuthApiService();

  // ✅ GET /auth/profile - Lấy thông tin user (dùng auth endpoint)
  Future<User?> getProfile() async {
    try {
      final response = await _apiService.getProfile();

      if (response == null) {
        print("❌ Get profile failed");
        return null;
      }

      // Xử lý nhiều format response
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

      print("✅ Lấy thông tin người dùng thành công");
      return User.fromJson(userData);
    } catch (e) {
      print("❌ Lỗi khi lấy thông tin người dùng: $e");
      return null;
    }
  }

  Future<SuccessResponse<User>?> updateProfile(User user) async {
    try {
      final response = await _apiService.updateProfile(user.toJson());

      if (response == null) {
        print("❌ Update profile failed");
        return null;
      }

      print("✅ Cập nhật thông tin người dùng thành công");

      return SuccessResponse.fromJson(
        response,
            (json) => User.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      print("❌ Lỗi khi cập nhật thông tin người dùng: $e");
      return null;
    }
  }

  Future<User?> updateUserField({
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

      if (data.isEmpty) {
        print("⚠️ Không có dữ liệu để cập nhật");
        return null;
      }

      final response = await _apiService.updateProfile(data);

      if (response == null) {
        print("❌ Update failed");
        return null;
      }

      // Parse user từ response
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

      print("✅ Cập nhật thành công");
      return User.fromJson(userData);
    } catch (e) {
      print("❌ Lỗi khi cập nhật: $e");
      return null;
    }
  }

  // ✅ Helper: Validate user data trước khi update
  String? validateUserData({
    String? email,
    String? username,
    String? firstName,
    String? lastName,
  }) {
    // Validate email
    if (email != null && email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        return 'Email không hợp lệ';
      }
    }

    // Validate username
    if (username != null && username.isNotEmpty) {
      if (username.length < 3) {
        return 'Username phải có ít nhất 3 ký tự';
      }
      if (username.length > 20) {
        return 'Username không được quá 20 ký tự';
      }
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
        return 'Username chỉ được chứa chữ cái, số và dấu gạch dưới';
      }
    }

    // Validate first name
    if (firstName != null && firstName.isNotEmpty) {
      if (firstName.length < 2) {
        return 'Tên phải có ít nhất 2 ký tự';
      }
    }

    // Validate last name
    if (lastName != null && lastName.isNotEmpty) {
      if (lastName.length < 2) {
        return 'Họ phải có ít nhất 2 ký tự';
      }
    }
    return null; // No errors
  }

  String getUserInitials(User user) {
    final first = user.firstName.isNotEmpty ? user.firstName[0] : '';
    final last = user.lastName.isNotEmpty ? user.lastName[0] : '';
    return (first + last).toUpperCase();
  }

  // ✅ Helper: Lấy full name
  String getUserFullName(User user) {
    return '${user.firstName} ${user.lastName}'.trim();
  }

  String formatLastLogin(DateTime? lastLogin) {
    if (lastLogin == null) return 'Chưa đăng nhập';

    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${(difference.inDays / 30).floor()} tháng trước';
    }
  }
} 
