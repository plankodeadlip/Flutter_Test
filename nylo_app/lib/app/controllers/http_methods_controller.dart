import 'package:flutter_app/app/models/post.dart';
import 'package:flutter_app/app/models/comment.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/controller.dart';

class HttpMethodsController extends Controller {
  final ApiService _api = ApiService();

  List<Post> posts = [];
  List<Post> allPosts = [];
  final int pageSize = 10;
  List<Post> filteredPosts = [];

  /// Lưu comment của từng post
  Map<int, List<Comment>> commentsByPost = {};
  /// Lưu danh sách comment đã lọc theo từ khóa (cho search)
  Map<int, List<Comment>> filteredCommentsByPost = {};
  /// Lưu số lượng comment của từng post
  Map<int, int> commentsCountByPost = {};

  // ---------------------------------------------------
  //  HTTP METHODS
  // ---------------------------------------------------

  Future<List<Post>> getMethod({int page = 1}) async {
    try {
      if (allPosts.isEmpty) {
        final data = await _api.getRequest();
        if (data != null) {
          allPosts = (data as List).map((e) => Post.fromJson(e)).toList();
          NyLogger.info("✅ GET thành công: ${allPosts.length} bài viết từ API");
        }

        // chỉ load số lượng comment, không load body
        await loadCommentsCountForPosts(allPosts);
      }

      final startIndex = (page - 1) * pageSize;
      final endIndex = (startIndex + pageSize).clamp(0, allPosts.length);

      if (startIndex >= allPosts.length) {
        NyLogger.info("⚠️ Không còn dữ liệu để tải (trang $page)");
        return [];
      }

      posts = allPosts.sublist(0, endIndex);
      NyLogger.info("📄 Trang $page - hiển thị ${posts.length}/${allPosts.length} bài");
      return posts;
    } catch (e) {
      NyLogger.error("❌ GET REQUEST thất bại: $e");
      return [];
    }
  }

  Future<bool> postMethod({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final newPost = await _api.postRequest({
        "title": title,
        "body": body,
        "userId": userId,
      });

      if (newPost != null) {
        final post = Post.fromJson(newPost);
        allPosts.insert(0, post);
        NyLogger.info("🆕 POST thành công - Đã thêm bài viết mới");
        return true;
      }

      NyLogger.error("POST thất bại - Không có dữ liệu trả về");
      return false;
    } catch (e) {
      NyLogger.error("❌ POST REQUEST thất bại: $e");
      return false;
    }
  }

  Future<bool> putMethod({
    required int postId,
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final updated = await _api.putRequest(postId, {
        "id": postId,
        "title": title,
        "body": body,
        "userId": userId,
      });

      if (updated != null) {
        final updatedPost = Post.fromJson(updated);
        final index = allPosts.indexWhere((p) => p.id == postId);
        if (index != -1) allPosts[index] = updatedPost;

        NyLogger.info("✏️ PUT thành công - Đã cập nhật post ID $postId");
        return true;
      }

      NyLogger.error("PUT thất bại - Không có dữ liệu trả về");
      return false;
    } catch (e) {
      NyLogger.error("❌ PUT REQUEST thất bại: $e");
      return false;
    }
  }

  Future<bool> deleteMethod({required int postId}) async {
    try {
      final result = await _api.deleteRequest(postId);
      if (result != null) {
        allPosts.removeWhere((p) => p.id == postId);
        posts.removeWhere((p) => p.id == postId);
        commentsByPost.remove(postId);
        NyLogger.info("🗑️ DELETE thành công - Đã xóa post ID $postId");
        return true;
      }

      NyLogger.error("DELETE thất bại - API không trả kết quả");
      return false;
    } catch (e) {
      NyLogger.error("❌ DELETE REQUEST thất bại: $e");
      return false;
    }
  }

  // ---------------------------------------------------
  //  COMMENT HANDLING
  // ---------------------------------------------------

  Future<void> getComments(int postId) async {
    // toggle hide
    if (commentsByPost.containsKey(postId) && commentsByPost[postId]!.isNotEmpty) {
      commentsByPost[postId] = [];
      filteredCommentsByPost[postId] = [];
      NyLogger.info("👁️ Ẩn comments cho post $postId");
      return;
    }

    try {
      NyLogger.info("🔄 Đang tải comments cho post $postId...");
      final comments = await Comment.getCommentsByPostId(postId);

      commentsByPost[postId] = comments;
      filteredCommentsByPost[postId] = comments;
      commentsCountByPost[postId] = comments.length;

      NyLogger.info("✅ Đã tải ${comments.length} comments cho post $postId");
    } catch (e) {
      NyLogger.error("❌ Lỗi khi tải comments cho post $postId: $e");
      commentsByPost[postId] = [];
      filteredCommentsByPost[postId] = [];
      commentsCountByPost[postId] = 0;
    }
  }

  /// Tìm kiếm comment theo name/email/body
  void searchComments(int postId, String query) {
    if (!commentsByPost.containsKey(postId)) return;

    if (query.isEmpty) {
      filteredCommentsByPost[postId] = commentsByPost[postId] ?? [];
      return;
    }

    final lower = query.toLowerCase();
    filteredCommentsByPost[postId] = commentsByPost[postId]!
        .where((c) =>
    c.name!.toLowerCase().contains(lower) ||
        c.email!.toLowerCase().contains(lower) ||
        c.body!.toLowerCase().contains(lower))
        .toList();
  }

  /// Chỉ load số lượng comment, không load nội dung
  Future<void> loadCommentsCountForPosts(List<Post> posts) async {
    try {
      commentsByPost.clear();
      // Tạo danh sách futures để chạy song song
      final futures = posts.map((post) async {
        final comments = await Comment.getCommentsByPostId(post.id);
        commentsCountByPost[post.id] = comments.length;
      }).toList();

      await Future.wait(futures); // chạy song song tất cả
      NyLogger.info("✅ Đã tải xong toàn bộ comment count cho ${posts.length} post.");
    } catch (e) {
      NyLogger.error("❌ Lỗi khi tải comment count: $e");
    }
  }

  Future<List<Post>> searchPostsWithComments(String query) async {
    if (query.isEmpty) return posts;

    final lower = query.toLowerCase();

    // 1️⃣ Lọc theo title/body
    final localFiltered = posts.where((post) {
      final titleMatch = (post.title ?? '').toLowerCase().contains(lower);
      final bodyMatch = (post.body ?? '').toLowerCase().contains(lower);
      return titleMatch || bodyMatch;
    }).toList();

    // 2️⃣ Tìm trong comment (tự động tải nếu chưa có)
    List<int> commentMatchedPostIds = [];

    for (var post in posts) {
      // Nếu comment chưa được tải -> tải comment
      if (!commentsByPost.containsKey(post.id)) {
        final comments = await Comment.getCommentsByPostId(post.id);
        commentsByPost[post.id] = comments;
        commentsCountByPost[post.id] = comments.length;
      }

      final comments = commentsByPost[post.id] ?? [];
      final hasMatch = comments.any((cmt) {
        return (cmt.name ?? '').toLowerCase().contains(lower) ||
            (cmt.email ?? '').toLowerCase().contains(lower) ||
            (cmt.body ?? '').toLowerCase().contains(lower);
      });

      if (hasMatch) {
        commentMatchedPostIds.add(post.id);
      }
    }

    // 3️⃣ Gom kết quả
    final allMatchedIds = {
      ...localFiltered.map((p) => p.id),
      ...commentMatchedPostIds,
    };

    // 4️⃣ Trả về danh sách post tương ứng
    return posts.where((p) => allMatchedIds.contains(p.id)).toList();
  }




  // ---------------------------------------------------
  //  UTILITY
  // ---------------------------------------------------

  void resetData() {
    posts.clear();
    allPosts.clear();
    commentsByPost.clear();
    filteredCommentsByPost.clear();
    commentsCountByPost.clear();
  }

  bool get hasMoreData => posts.length < allPosts.length;
  int get totalPosts => allPosts.length;
  int get currentPage => (posts.length / pageSize).ceil();
}
