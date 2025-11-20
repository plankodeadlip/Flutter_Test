import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/controllers/http_methods_controller.dart';
import '../../app/forms/create_post_dialog_form.dart';
import '../../app/forms/delete_post_dialog_form.dart';
import '../../app/forms/update_post_dialog_form.dart';
import '../../app/models/post.dart';
import '../../app/networking/api_service.dart';

class HttpMethodsPage extends NyStatefulWidget<HttpMethodsController> {
  static RouteView path = ("/http_method", (_) => HttpMethodsPage());

  HttpMethodsPage({super.key}) : super(child: () => _HttpMethodsPageState());

  @override
  createState() => _HttpMethodsPageState();
}

class _HttpMethodsPageState extends NyPage<HttpMethodsPage> {
  bool isLoadingPage = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  static const int POSTS_PER_PAGE = 10; // Limit = 10 posts per page
  final ApiService api = ApiService();
  Post? selectedPost;
  bool showOptionBar = false;
  Timer? _debounce;
  bool isRequestingMore = false;
  Set<int> openCommentPosts = {};
  bool isSearching = false;

  int searchPage = 1;
  String searchQuery = '';
  bool searchHasMore = true;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  get init => () async {
    widget.controller.clearCache();
    await _loadInitialPosts();
    _scrollController.addListener(_onScroll);
  };

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore) {

      if (isSearching && searchHasMore) {
        _loadMoreSearchPost();
      } else if (!isSearching && hasMore) {
        _loadMorePost();
      }
    }
  }


  Future<void> _loadInitialPosts() async {
    NyLogger.info("🔄 Loading initial posts...");

    setState(() {
      isLoadingPage = true;
      currentPage = 1;
      hasMore = true;
    });

    // Load trang đầu tiên với limit = 10
    final loadedPosts = await widget.controller.getMethod(page: 1, limit: POSTS_PER_PAGE);
    NyLogger.info("📋 Loaded ${loadedPosts.length} posts from API");
    NyLogger.info("📋 Controller now has ${widget.controller.posts.length} posts");

    // Load comment count cho các posts vừa tải (batch loading)
    if (loadedPosts.isNotEmpty) {
      await widget.controller.loadCommentsCountForPosts(loadedPosts);
      NyLogger.info("💬 Loaded comment counts");
    }

    setState(() {
      isLoadingPage = false;
      // Nếu số posts nhận được = POSTS_PER_PAGE, có thể còn trang tiếp theo
      hasMore = loadedPosts.length >= POSTS_PER_PAGE;
      NyLogger.info("✅ Initial load complete. hasMore: $hasMore");
    });
  }

  Future<void> _loadMoreSearchPost() async {
    if (isRequestingMore) return;

    setState(() {
      isRequestingMore = true;
      isLoadingMore = true;
    });

    try {
      searchPage++;
      NyLogger.info("📄 Loading search page $searchPage for '$searchQuery'...");

      final newResults = await api.searchPostsByAPI(searchQuery, searchPage, POSTS_PER_PAGE);

      setState(() {
        widget.controller.posts.addAll(newResults);
        isLoadingMore = false;
        searchHasMore = newResults.length >= POSTS_PER_PAGE;
      });

      NyLogger.info("✅ Loaded search page $searchPage, total posts: ${widget.controller.posts.length}");
    } catch (e) {
      NyLogger.error("❌ Load more search error: $e");
      searchPage--;
      setState(() {
        isLoadingMore = false;
      });
    } finally {
      isRequestingMore = false;
    }
  }


  Future<void> _loadMorePost() async {
    if (isRequestingMore || isSearching) {
      NyLogger.info("⚠️ Already loading or searching, skipping load more");
      return;
    }

    setState(() {
      isRequestingMore = true;
      isLoadingMore = true;
    });

    try {
      currentPage++;
      NyLogger.info("📄 Loading page $currentPage...");

      // Load trang tiếp theo
      final newPosts = await widget.controller.getMethod(
        page: currentPage,
        limit: POSTS_PER_PAGE,
      );

      // Load comment count cho posts mới (batch loading)
      if (newPosts.isNotEmpty) {
        await widget.controller.loadCommentsCountForPosts(newPosts);
      }

      setState(() {
        isLoadingMore = false;
        hasMore = newPosts.length >= POSTS_PER_PAGE;

        NyLogger.info("✅ Load more complete. hasMore: $hasMore, total posts: ${widget.controller.posts.length}");
      });
    } catch (e) {
      NyLogger.error("❌ Load more error: $e");
      currentPage--; // Rollback page number on error
      setState(() {
        isLoadingMore = false;
      });
    } finally {
      isRequestingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.controller.posts;

    // Lọc posts theo search query
    final filteredPosts = _filterPosts(posts);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Http Methods",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              // Search Bar
              _buildSearchBar(),
              SizedBox(height: 10),

              // GET/POST Buttons
              _buildActionButtons(),
              SizedBox(height: 10),

              // Posts List
              Expanded(
                child: _buildPostsList(filteredPosts),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SearchBar(
        controller: _searchController,
        hintText: "Search...",
        leading: isLoadingPage && searchQuery.isNotEmpty
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Icon(Icons.search, color: Colors.grey),
        trailing: searchQuery.isNotEmpty
            ? [
          IconButton(
            onPressed: () async {
              _searchController.clear();
              setState(() {
                searchQuery = '';
                isSearching = false;
                isLoadingPage = true;
              });

              // Reset về trang 1 khi clear search
              await _loadInitialPosts();
            },
            icon: Icon(Icons.clear, color: Colors.grey),
          )
        ]
            : null,
        backgroundColor: const WidgetStatePropertyAll(Colors.white), // Màu nền
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18), // Bo tròn góc
            side: const BorderSide(color: Colors.blueAccent), // Đường viền
          ),
        ),
        elevation: const WidgetStatePropertyAll(1.0),
        onChanged: (value) {
          // Cancel previous debounce
          if (_debounce?.isActive ?? false) _debounce!.cancel();

          // Debounce search
          _debounce = Timer(const Duration(milliseconds: 500), () async {
            await _performSearch(value);
          });
        },
      ),
    );
  }
  Future<void> _performSearch(String value) async {
    value = value.trim();
    // Case 1: Empty search - load lại trang 1
    if (value.isEmpty) {
      setState(() {
        searchQuery = '';
        isSearching = false;
        searchPage = 1;
        searchHasMore = true;
      });
      await _loadInitialPosts();
      return;
    }

    // Case 2: Có query - thực hiện search
    setState(() {
      searchQuery = value;
      isSearching = true;
      isLoadingPage = true;
      searchPage = 1;
      searchHasMore = true;
      widget.controller.posts = [];
    });

    try {

      // Search trong tất cả posts đã load
      final results = await api.searchPostsByAPI(value,searchPage,POSTS_PER_PAGE);

      setState(() {
        // Cập nhật kết quả search (không thay đổi controller.posts gốc)
        widget.controller.posts = results;
        isLoadingPage = false;
        searchHasMore = results.length >= POSTS_PER_PAGE;
      });

      NyLogger.info("🔍 Search '$value': Found ${results.length} results");
    } catch (e) {
      NyLogger.error("❌ Search error: $e");
      setState(() {
        isLoadingPage = false;
      });
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildButton(
            label: "GET",
            color: Colors.blue,
            onTap: () async {
              _searchController.clear();
              setState(() {
                searchQuery = '';
                isSearching = false;
              });
              await _loadInitialPosts();
              NyLogger.info('✅ GET REQUEST - Loaded page 1 with $POSTS_PER_PAGE posts');
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildButton(
            label: "POST",
            color: Colors.green,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CreatePostDialogForm(
                  controller: widget.controller,
                  onSuccess: () async {
                    await _loadInitialPosts();
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPostsList(List<Post> filteredPosts) {
    if (isLoadingPage) {
      return Center(child: CircularProgressIndicator());
    }

    if (filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              searchQuery.isEmpty
                  ? 'Không có bài viết nào'
                  : 'Không tìm thấy kết quả cho "$searchQuery"',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _searchController.clear();
        setState(() {
          searchQuery = '';
          isSearching = false;
        });
        await _loadInitialPosts();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: filteredPosts.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == filteredPosts.length) {
            return Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final post = filteredPosts[i];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    final isSelected = selectedPost?.id == post.id;
    final postComments = widget.controller.commentsByPost[post.id] ?? [];
    final commentsCount = widget.controller.commentsCountByPost[post.id] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: isSelected ? 4 : 1,
      child: Column(
        children: [
          ListTile(
            title: Text(
              post.title ?? "Không có tiêu đề",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              post.body ?? "Không có body",
              style: TextStyle(color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onLongPress: () {
              setState(() {
                selectedPost = selectedPost?.id == post.id ? null : post;
              });
            },
            trailing: _buildCommentButton(post, commentsCount),
          ),

          // Comments Section
          if (openCommentPosts.contains(post.id))
            _buildCommentsSection(post, postComments),

          // Action Buttons (PUT/DELETE)
          if (isSelected) _buildActionButtonsForPost(post),
        ],
      ),
    );
  }

  Widget _buildCommentButton(Post post, int commentsCount) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      onPressed: () async {
        if (openCommentPosts.contains(post.id)) {
          // Đóng comments
          setState(() {
            openCommentPosts.remove(post.id);
          });
        } else {
          // Mở comments
          setState(() {
            openCommentPosts.add(post.id);
          });

          // Load comments nếu chưa có (với cache)
          if (widget.controller.commentsByPost[post.id] == null ||
              widget.controller.commentsByPost[post.id]!.isEmpty) {
            await widget.controller.loadCommentsForPost(post.id);
            setState(() {});

            final comments = widget.controller.commentsByPost[post.id] ?? [];
            NyLogger.info("💬 Loaded ${comments.length} comments for Post ${post.id}");
          }
        }
      },
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            openCommentPosts.contains(post.id)
                ? Icons.expand_less
                : Icons.expand_more,
            color: Colors.grey,
          ),
          SizedBox(width: 4),
          Icon(Icons.comment, color: Colors.grey),
          SizedBox(width: 4),
          Text(
            "$commentsCount",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection(Post post, List<dynamic> postComments) {
    // Kiểm tra xem comments đã được load chưa
    final isLoadingComments = openCommentPosts.contains(post.id) &&
        postComments.isEmpty &&
        widget.controller.commentsByPost[post.id] == null;

    // Hiển thị loading indicator khi đang tải comments
    if (isLoadingComments) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Hiển thị thông báo không có comment
    if (postComments.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Không có comment nào",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Hiển thị danh sách comments
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: postComments.map((cmt) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cmt.name ?? "Anonymous",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (cmt.email != null && cmt.email!.isNotEmpty)
                  Text(
                    cmt.email!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                SizedBox(height: 6),
                Text(
                  cmt.body ?? "Không có nội dung",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget _buildActionButtonsForPost(Post post) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildButton(
              label: "PUT",
              color: Colors.purple,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => UpdatePostDialogForm(
                    controller: widget.controller,
                    post: post,
                    onSuccess: () async {
                      await _loadInitialPosts();
                      setState(() {
                        selectedPost = null;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildButton(
              label: "DELETE",
              color: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => DeletePostDialogForm(
                    controller: widget.controller,
                    post: post,
                    onSuccess: () async {
                      await _loadInitialPosts();
                      setState(() {
                        selectedPost = null;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Post> _filterPosts(List<Post> posts) {
    if (searchQuery.isEmpty) return posts;

    final q = searchQuery.toLowerCase();

    return posts.where((post) {
      final titleMatch = (post.title ?? '').toLowerCase().contains(q);
      final bodyMatch = (post.body ?? '').toLowerCase().contains(q);

      final comments = widget.controller.commentsByPost[post.id] ?? [];
      final commentMatch = comments.any((cmt) =>
      (cmt.name ?? '').toLowerCase().contains(q) ||
          (cmt.email ?? '').toLowerCase().contains(q) ||
          (cmt.body ?? '').toLowerCase().contains(q));

      return titleMatch || bodyMatch || commentMatch;
    }).toList();
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 3, color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}