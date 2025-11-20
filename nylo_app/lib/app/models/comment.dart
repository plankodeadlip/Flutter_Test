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

  /// Fetch comments for a single post (with built-in caching check)
  static Future<List<Comment>> getCommentsByPostId(
      int postId, {
        Map<int, List<Comment>>? cache,
      }) async {
    // Check cache first
    if (cache != null && cache.containsKey(postId)) {
      NyLogger.info("🎯 Cache hit for postId=$postId");
      return cache[postId]!;
    }

    try {
      final api = ApiService();
      final response = await api.getComments(postId: postId);

      if (response.isEmpty) {
        NyLogger.info("ℹ️ No comments found for postId=$postId");
        return [];
      }

      // Direct mapping without redundant filtering
      final comments = response
          .map((json) => Comment.fromJson(json))
          .toList();

      NyLogger.info("✅ Loaded ${comments.length} comments for postId=$postId");

      // Update cache if provided
      if (cache != null) {
        cache[postId] = comments;
      }

      return comments;
    } catch (e) {
      NyLogger.error("❌ Error fetching comments for post $postId: $e");
      return [];
    }
  }

  /// Load comments for multiple posts in parallel (batch loading)
  static Future<Map<int, List<Comment>>> loadCommentsForPosts(
      List<int> postIds, {
        Map<int, List<Comment>>? existingCache,
      }) async {
    final cache = existingCache ?? <int, List<Comment>>{};

    // Filter out already cached posts
    final uncachedPostIds = postIds
        .where((id) => !cache.containsKey(id))
        .toSet()
        .toList();

    if (uncachedPostIds.isEmpty) {
      NyLogger.info("✅ All posts already cached");
      return cache;
    }

    NyLogger.info("⚡️ Loading comments for ${uncachedPostIds.length} posts in parallel...");

    // Load all in parallel with error isolation
    final results = await Future.wait(
      uncachedPostIds.map((postId) async {
        try {
          final comments = await getCommentsByPostId(postId, cache: cache);
          return MapEntry(postId, comments);
        } catch (e) {
          NyLogger.error("❌ Failed to load comments for post $postId: $e");
          return MapEntry(postId, <Comment>[]);
        }
      }),
    );

    // Merge results into cache
    for (final entry in results) {
      cache[entry.key] = entry.value;
    }

    NyLogger.info("✅ Batch loading complete");
    return cache;
  }


  /// Helper method to check if a comment matches the query

  /// Pre-load all comments for better UX (call on app start or when needed)
  static Future<Map<int, List<Comment>>> preloadAllComments(
      List<Post> allPosts,
      ) async {
    final postIds = allPosts.map((p) => p.id).toList();
    NyLogger.info("🚀 Preloading comments for ${postIds.length} posts...");

    return await loadCommentsForPosts(postIds);
  }
}