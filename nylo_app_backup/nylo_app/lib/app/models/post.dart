import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter_app/app/networking/api_service.dart';

class Post extends Model {
  final int id;
  String? title;
  String? body;
  final int userId;

  Post({
    required this.id,
    this.title,
    this.body,
    required this.userId,
  });

  // 🧩 Tạo Post từ JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    final rawTitle = json['title']?.toString().trim();
    final rawBody = json['body']?.toString().trim();

    return Post(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: (rawTitle != null && rawTitle.isNotEmpty)
          ? rawTitle
          : '(Không có tiêu đề)',
      body: (rawBody != null && rawBody.isNotEmpty)
          ? rawBody
          : '(Không có nội dung)',
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
    );
  }

  // 🧩 Chuyển Post thành JSON (gửi API)
  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "userId": userId,
      };

  // 🧩 Hiển thị dễ hiểu khi debug hoặc log
  @override
  String toString() {
    return 'Post{id: $id, title: $title, body: $body, userId: $userId}';
  }

  // ========================
  // STATIC METHODS - Business Logic
  // ========================

  /// Lấy danh sách posts từ API với phân trang

  static Future<List<Post>> fetchPosts({
    int page = 1,
    int pageSize = 10,
    required List<Post> allPosts,
  }) async {
    try {
      NyLogger.info("Đang gọi GET page = $page...");

      if (allPosts.isEmpty) {
        final apiService = ApiService();
        final result = await apiService.getRequest();

        if (result == null) {
          NyLogger.error("Không nhận được dữ liệu từ API");
          return [];
        }

        NyLogger.info("Response data: $result");

        final data = (result is List) ? result : (result['data'] ?? []);

        allPosts.clear();
        allPosts.addAll(
          data
              .map<Post>((e) => Post.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );

        NyLogger.info('GET MESSAGE thành công - ${allPosts.length} bài viết');
      }

      // Phân trang
      int startIndex = (page - 1) * pageSize;
      int endIndex = startIndex + pageSize;

      if (startIndex >= allPosts.length) {
        NyLogger.info("Không còn dữ liệu để tải thêm (page = $page)");
        return [];
      }

      if (endIndex > allPosts.length) {
        endIndex = allPosts.length;
      }

      List<Post> pageResults = allPosts.sublist(startIndex, endIndex);
      NyLogger.info("Đã tải ${pageResults.length} bài viết (page=$page)");

      return pageResults;
    } catch (e, s) {
      NyLogger.error("Lỗi khi gọi GET: $e");
      NyLogger.error(s.toString());
      return [];
    }
  }

  static Future<Post?> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    try {
      final newPostData = {"title": title, "body": body, "userId": userId};

      final apiService = ApiService();
      final result = await apiService.postRequest(newPostData);

      if (result != null) {
        NyLogger.info("POST REQUEST thành công");
        final postData = result is Map<String, dynamic>
            ? result
            : Map<String, dynamic>.from(result);
        if (!postData.containsKey('userId')) {
          postData['userId'] = userId;
        }
        return Post.fromJson(postData);
      }

      return null;
    } catch (e, s) {
      NyLogger.error("Lỗi khi tạo post: $e");
      NyLogger.error(s.toString());
      return null;
    }
  }

  static Future<Post?> updatePost({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final updateData = {
        "id": id,
        "title": title,
        "body": body,
        "userId": userId,
      };

      final apiService = ApiService();
      final result = await apiService.putRequest(id, updateData);

      if (result != null) {
        NyLogger.info("PUT REQUEST thành công cho post #$id");
        final updatedJson = result is Map<String, dynamic>
            ? result
            : Map<String, dynamic>.from(result);
        return Post.fromJson(updatedJson);
      }

      NyLogger.error("PUT REQUEST thất bại cho post #$id");
      return null;
    } catch (e, s) {
      NyLogger.error("Lỗi khi cập nhật post #$id: $e");
      NyLogger.error(s.toString());
      return null;
    }
  }

  Future<Post?> update({
    String? newTitle,
    String? newBody,
  }) async {
    try {
      final updateData = {
        "id": id,
        "title": newTitle ?? title,
        "body": newBody ?? body,
        "userId": userId
      };

      final apiService = ApiService();
      await apiService.putRequest(id, updateData);

      if (newTitle != null) title = newTitle;
      if (newBody != null) body = newBody;

      NyLogger.info("PUT REQUEST đã gửi thành công post #$id");
      return this;
    } catch (e, s) {
      NyLogger.error("Lỗi khi cập nhật post #$id: $e");
      NyLogger.error(s.toString());
      return null;
    }
  }

  static Future<List<Post>> updateMultiple(
      List<Map<String, dynamic>> updates) async {
    List<Post> updatePosts = [];

    for (var updateData in updates) {
      try {
        final id = updateData['id'] as int;
        final apiService = ApiService();
        await apiService.putRequest(id, updateData);

        updatePosts.add(Post.fromJson(updateData));
        NyLogger.info("PUT REQUEST thành công cho post #$id");
      } catch (e) {
        NyLogger.error("Lỗi khi nhập post: $e");
      }
    }
    return updatePosts;
  }

  Future<bool> delete() async {
    try {
      final apiService = ApiService();
      await apiService.deleteRequest(id);
      NyLogger.info("DELETE REQUEST thành công cho post #$id");
      return true;
    } catch (e, s) {
      NyLogger.error("Lỗi khi xóa post #$id: $e");
      NyLogger.error(s.toString());
      return false;
    }
  }

  static Future<bool> deleteById(int id) async {
    try {
      final apiService = ApiService();
      await apiService.deleteRequest(id);

      NyLogger.info("DELETE REQUEST thành công cho post #$id");
      return true;
    } catch (e, s) {
      NyLogger.error("Lỗi khi xóa post #$id : $e");
      NyLogger.error(s.toString());
      return false;
    }
  }

  static List<Post> sortByIdDecending(List<Post> posts) {
    posts.sort((a, b) => b.id.compareTo(a.id));
    return posts;
  }

  static Post? findById(List<Post> posts, int id) {
    try {
      return posts.firstWhere((posts) => posts.id == id);
    } catch (e) {
      return null;
    }
  }

  static int findIndexById(List<Post> posts, int id) {
    return posts.indexWhere((posts) => posts.id == id);
  }
}
