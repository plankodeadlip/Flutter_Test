import 'package:flutter_app/app/models/post.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter_app/app/networking/api_service.dart';

class Comment extends Model {
  int? postId;
  int? id;
  String? name;
  String? email;
  String? body;

  Comment({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: int.tryParse(json['postId'].toString()),
      id: int.tryParse(json['id'].toString()),
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "postId": postId,
        "id": id,
        "name": name,
        "email": email,
        "body": body,
      };

  @override
  String toString() {
    return 'Comment{postId:$postId, id: $id, name:$name, email: $email, body: $body}';
  }

  static Future<List<Comment>> getCommentsByPostId(int postId) async {
    try {
      final api = ApiService();

      final response = await api.getComments(
        postId: postId,
        onSuccess: (data) {
          NyLogger.info("✅ Fetched ${data.length} comments for post $postId");
        },
        onFailure: (message) {
          NyLogger.error("❌ Failed to load comments: $message");
        },
      );

      if (response.isNotEmpty) {
        // Chuyển JSON sang Comment
        final comments = response.map((e) => Comment.fromJson(e)).toList();
        // Lọc chỉ những comment có postId đúng
        final filteredComments = comments.where((c) => c.postId == postId).toList();

        NyLogger.info("ℹ️ After filtering, ${filteredComments.length} comments belong to postId=$postId");

        return filteredComments;
      }

      return [];
    } catch (e) {
      NyLogger.error("❌ Error fetching comments for post $postId: $e");
      return [];
    }
  }

  // Trong class Comment (thêm các hàm sau)


  // ---------------------------------------------------
//  SEARCH HANDLING (LOGIC MỚI)
// ---------------------------------------------------

  /// Tải comment chi tiết cho 1 post NẾU CHƯA TẢI
  static Future<void> loadCommentsForPost(int postId, Map<int, List<Comment>> commentsCache) async {
    // Nếu đã tải rồi thì bỏ qua
    if (commentsCache.containsKey(postId) && commentsCache[postId]!.isNotEmpty) {
      return;
    }

    try {
      NyLogger.info("🔄 (Comment.load) Đang tải comments cho post $postId...");
      final comments = await getCommentsByPostId(postId);
      commentsCache[postId] = comments;
    } catch (e) {
      NyLogger.error("❌ (Comment.load) Lỗi khi tải comments cho post $postId: $e");
      commentsCache[postId] = [];
    }
  }


  /// 2. Tìm kiếm chính: Tải tất cả comment và trả về ID của các Post có comment khớp
  static Future<Set<int>> searchPostsByComment({
    required String query,
    required List<Post> allPosts,
    required Map<int, List<Comment>> commentsCache,
  }) async {
    if (query.isEmpty) return {};

    final lower = query.toLowerCase();

    // 1. Đảm bảo TẤT CẢ comment cho TẤT CẢ post (trong allPosts) đều đã được tải
    await ensureAllCommentsLoadedForSearch(
      allPosts: allPosts,
      commentsCache: commentsCache,
    );
    NyLogger.info("✅ Hoàn tất tải comment cho tìm kiếm.");

    // 2. Lọc
    final matchingPostIds = <int>{};
    commentsCache.forEach((postId, comments) {
      final hasMatch = comments.any((c) =>
      (c.name?.toLowerCase().contains(lower) ?? false) ||
          (c.email?.toLowerCase().contains(lower) ?? false) ||
          (c.body?.toLowerCase().contains(lower) ?? false));

      if (hasMatch) {
        matchingPostIds.add(postId);
      }
    });

    return matchingPostIds;
  }

  static Future<void> ensureAllCommentsLoadedForSearch({
    required List<Post> allPosts,
    required Map<int, List<Comment>> commentsCache,
  }) async {
    NyLogger.info("🔄 Kiểm tra comment cache trước khi tìm kiếm...");

    // Lọc ra những post chưa có comment trong cache
    final postsToLoad = allPosts.where((p) =>
    !commentsCache.containsKey(p.id) || commentsCache[p.id]!.isEmpty).toList();

    if (postsToLoad.isEmpty) {
      NyLogger.info("✅ Tất cả comment đã có trong cache, không cần tải thêm.");
      return;
    }

    NyLogger.info("⚡️ Cần tải comment cho ${postsToLoad.length} post chưa có dữ liệu...");

    // Dùng Future.wait để tải song song
    final futures = postsToLoad.map((p) async {
      try {
        final comments = await getCommentsByPostId(p.id);
        commentsCache[p.id] = comments;
        NyLogger.info("✅ Tải xong ${comments.length} comment cho post ${p.id}");
      } catch (e) {
        NyLogger.error("❌ Lỗi khi tải comment cho post ${p.id}: $e");
        commentsCache[p.id] = [];
      }
    }).toList();

    await Future.wait(futures);

    NyLogger.info("✅ Đảm bảo toàn bộ comment đã được tải đầy đủ để tìm kiếm.");
  }
}
