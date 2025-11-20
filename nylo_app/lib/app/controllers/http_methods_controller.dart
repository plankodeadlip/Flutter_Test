import 'package:flutter_app/app/models/post.dart';
import 'package:flutter_app/app/models/comment.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/controller.dart';

class HttpMethodsController extends Controller {
  final _api = ApiService();

  List<Post> posts = [];
  List<Post> allPosts = [];
  int pageSize = 10;


  /// Lưu comment của từng post
  Map<int, List<Comment>> commentsByPost = {};

  /// Lưu số lượng comment của từng post
  Map<int, int> commentsCountByPost = {};

  // ---------------------------------------------------
  //  HTTP METHODS
  // ---------------------------------------------------

  Future<List<Post>> getMethod({required int page, required int limit}) async {
    try {

      final response = await _api.getRequest(page: page, limit: 10);

      if (response!.isEmpty) {
        NyLogger.info("⚠️ No posts found for page $page");

        // convert API -> Post

        // nếu là trang đầu tiên → reset
        if (page == 1) {
          posts = [];
          allPosts = [];

        }
        return [];
      }

      final newPosts = response.map((e) => Post.fromJson(e)).toList();

      if (page == 1) {
        // Reset khi load trang đầu
        posts = List.from(newPosts);      // Copy mới
        allPosts = List.from(newPosts);
        NyLogger.info("✅ Loaded ${newPosts.length} posts (page 1, RESET)");
      } else {
        final existingIds = posts.map((p) => p.id).toSet();
        final uniqueNewPosts = newPosts.where((p) => !existingIds.contains(p.id)).toList();

        final duplicateCount = newPosts.length - uniqueNewPosts.length;

        if (uniqueNewPosts.isEmpty) {
          NyLogger.info("⚠️ All ${newPosts.length} posts from page $page are duplicates!");
          return [];
        }

        if (duplicateCount > 0) {
          NyLogger.info("⚠️ Found $duplicateCount duplicates in page $page");
        }

        // Append khi load thêm
        posts.addAll(uniqueNewPosts);
        allPosts.addAll(uniqueNewPosts);
        NyLogger.info("✅ Loaded ${newPosts.length} posts (page $page, total: ${allPosts.length})");
      }
      return newPosts;
    } catch (e) {
      NyLogger.error("❌ GET REQUEST thất bại: $e");
      if (page == 1) {
        posts = [];allPosts = [];
      }
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
        commentsCountByPost.remove(postId);
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

  Future<void> loadCommentsCountForPosts(List<Post> posts) async {
    if (posts.isEmpty) return;

    try {
      // Load tất cả comments một lần
      final allComments = await _api.getAllComments();

      if (allComments == null || allComments.isEmpty) {
        NyLogger.info("⚠️ No comments found");
        return;
      }

      // Group comments by postId
      final Map<int, int> counts = {};
      for (var comment in allComments) {
        final postId = int.tryParse(comment['postId']?.toString() ?? '');
        if (postId != null) {
          counts[postId] = (counts[postId] ?? 0) + 1;
        }
      }

      // Update counts cho các posts hiện tại
      for (var post in posts) {
        commentsCountByPost[post.id] = counts[post.id] ?? 0;
      }

      NyLogger.info("✅ Loaded comment counts for ${posts.length} posts");
    } catch (e) {
      NyLogger.error("❌ Error loading comments count: $e");
    }
  }

  Future<void> loadCommentsForPost(int postId) async {
    if (commentsByPost.containsKey(postId) && commentsByPost[postId]!.isNotEmpty) return; // đã load rồi
    try {
      final comments = await Comment.getCommentsByPostId(postId);
      commentsByPost[postId] = comments;
      commentsCountByPost[postId] = comments.length;
      NyLogger.info("✅ Đã tải ${comments.length} comment cho post $postId");
    } catch (e) {
      NyLogger.error("❌ Lỗi khi tải comment cho post $postId: $e");
      commentsByPost[postId] = [];
      commentsCountByPost[postId] = 0;
    }
  }

  Future<void> toggleComments(int postId) async {
    if (commentsByPost.containsKey(postId) && commentsByPost[postId]!.isNotEmpty) {
      // hide comment
      commentsByPost[postId] = [];
    } else {
      await loadCommentsForPost(postId);
    }
  }

  /// Tìm kiếm comment theo name/email/body

  // ---------------------------------------------------
  //  UTILITY
  // ---------------------------------------------------

  void resetData() {
    posts.clear();
    allPosts.clear();
    commentsByPost.clear();
    commentsCountByPost.clear();
  }

  void clearCache() {
    posts.clear();
    allPosts.clear();
    commentsByPost.clear();
    commentsCountByPost.clear();
    NyLogger.info("🗑️ Cache cleared");
  }

  void checkForDuplicates() {
    // Check posts
    final postsIds = posts.map((p) => p.id).toList();
    final postsUniqueIds = postsIds.toSet();

    if (postsIds.length != postsUniqueIds.length) {
      final duplicateCount = postsIds.length - postsUniqueIds.length;
      NyLogger.error("⚠️ FOUND $duplicateCount DUPLICATES in posts list!");
    } else {
      NyLogger.info("✅ posts: No duplicates (${posts.length} unique)");
    }

    // Check allPosts
    final allPostsIds = allPosts.map((p) => p.id).toList();
    final allPostsUniqueIds = allPostsIds.toSet();

    if (allPostsIds.length != allPostsUniqueIds.length) {
      final duplicateCount = allPostsIds.length - allPostsUniqueIds.length;
      NyLogger.error("⚠️ FOUND $duplicateCount DUPLICATES in allPosts list!");
    } else {
      NyLogger.info("✅ allPosts: No duplicates (${allPosts.length} unique)");
    }
  }

  /// Remove duplicates from posts list (emergency fix)
  void removeDuplicates() {
    // Clean posts
    final uniquePosts = <int, Post>{};
    for (var post in posts) {
      uniquePosts[post.id] = post;
    }
    final beforePostsCount = posts.length;
    posts = uniquePosts.values.toList();

    if (beforePostsCount != posts.length) {
      NyLogger.info("🧹 Removed ${beforePostsCount - posts.length} duplicates from posts");
    }

    // Clean allPosts
    final uniqueAllPosts = <int, Post>{};
    for (var post in allPosts) {
      uniqueAllPosts[post.id] = post;
    }
    final beforeAllPostsCount = allPosts.length;
    allPosts = uniqueAllPosts.values.toList();

    if (beforeAllPostsCount != allPosts.length) {
      NyLogger.info("🧹 Removed ${beforeAllPostsCount - allPosts.length} duplicates from allPosts");
    }

    if (beforePostsCount == posts.length && beforeAllPostsCount == allPosts.length) {
      NyLogger.info("✅ No duplicates to remove");
    }
  }



  bool get hasMoreData => posts.length < allPosts.length;
  int get totalPosts => allPosts.length;
  int get currentPage => (posts.length / pageSize).ceil();
}
