import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/controllers/http_methods_controller.dart';
import '../../app/forms/create_post_dialog_form.dart';
import '../../app/forms/delete_post_dialog_form.dart';
import '../../app/forms/update_post_dialog_form.dart';
import '../../app/models/post.dart';

class HttpMethodsPage extends NyStatefulWidget<HttpMethodsController> {
  HttpMethodsPage({super.key});

  @override
  createState() => _HttpMethodsPageState();
}

class _HttpMethodsPageState extends NyPage<HttpMethodsPage> {
  bool isLoadingPage = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  Post? selectedPost;
  bool showOptionBar = false;

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  get init => () async {
    await _loadInitialPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !isLoadingMore &&
          hasMore) {
        _loadMorePost();
      }
    });
  };

  Future<void> _loadInitialPosts() async {
    setState(() => isLoadingPage = true);
    currentPage = 1;
    await widget.controller.getMethod(page: currentPage);
    await widget.controller.loadCommentsCountForPosts(widget.controller.posts);

    setState(() {
      isLoadingPage = false;
      hasMore = widget.controller.allPosts.length >= 20;
    });
  }

  Future<void> _loadMorePost() async {
    setState(() => isLoadingMore = true);
    currentPage++;
    final newPosts = await widget.controller.getMethod(page: currentPage);
    setState(() {
      isLoadingMore = false;
      hasMore = newPosts.isNotEmpty;
    });
  }

  @override
  Widget view(BuildContext context) {
    final posts = widget.controller.posts;

    // Nếu có query tìm kiếm, lọc post theo cả tiêu đề, nội dung, và comment
    final filteredPosts = posts.where((post) {
      if (searchQuery.isEmpty) return true;

      final q = searchQuery.toLowerCase();
      final titleMatch = (post.title ?? '').toLowerCase().contains(q);
      final bodyMatch = (post.body ?? '').toLowerCase().contains(q);

      final comments = widget.controller.commentsByPost[post.id] ?? [];
      final commentMatch = comments.any((cmt) =>
      (cmt.name ?? '').toLowerCase().contains(q) ||
          (cmt.email ?? '').toLowerCase().contains(q) ||
          (cmt.body ?? '').toLowerCase().contains(q));

      return titleMatch || bodyMatch || commentMatch;
    }).toList();

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
              color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  // Ô tìm kiếm
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm bài viết hoặc comment...",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      onChanged: (value) async {
                        setState(() {
                          searchQuery = value;
                          isLoadingPage = true;
                        });

                        final results = await widget.controller.searchPostsWithComments(value);

                        setState(() {
                          widget.controller.filteredPosts = results;
                          isLoadingPage = false;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),


                  // Nút GET/POST
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildButton(
                          label: "GET",
                          color: Colors.blue,
                          onTap: () async {
                            await _loadInitialPosts();
                            NyLogger.info('ĐÃ GỬI GET REQUEST');
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
                  ),
                  SizedBox(height: 10),

                  // Danh sách post
                  Expanded(
                    flex: 8,
                    child: isLoadingPage
                        ? Center(child: CircularProgressIndicator())
                        : filteredPosts.isEmpty
                        ? Center(child: Text('Không tìm thấy kết quả.'))
                        : RefreshIndicator(
                      onRefresh: _loadInitialPosts,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: filteredPosts.length +
                            (isLoadingMore ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (i == filteredPosts.length) {
                            return Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(
                                  child: CircularProgressIndicator()),
                            );
                          }

                          final post = filteredPosts[i];
                          final isSelected =
                              selectedPost?.id == post.id;
                          final postComments = widget
                              .controller
                              .commentsByPost[post.id] ??
                              [];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    post.title ?? "Không có tiêu đề",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    post.body ?? "Không có body",
                                    style: TextStyle(
                                        color: Colors.grey),
                                  ),
                                  onLongPress: () {
                                    setState(() {
                                      if (selectedPost?.id ==
                                          post.id) {
                                        selectedPost = null;
                                      } else {
                                        selectedPost = post;
                                      }
                                    });
                                  },
                                  trailing: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () async {
                                      await widget.controller
                                          .getComments(post.id);
                                      setState(() {});
                                    },
                                    icon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.comment,
                                            color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text(
                                          "${widget.controller.commentsCountByPost[post.id] ?? 0}",
                                          style: TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Hiển thị comment nếu có
                                if (postComments.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Column(
                                      children: postComments
                                          .map(
                                            (cmt) => Container(
                                              width: double.infinity,
                                          margin: EdgeInsets.only(
                                              bottom: 8),
                                          padding:
                                          EdgeInsets.all(12),
                                          decoration:
                                          BoxDecoration(
                                            color: Colors
                                                .grey.shade100,
                                            borderRadius:
                                            BorderRadius
                                                .circular(8),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .shade300),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                cmt.name ??
                                                    "Anonymous",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color: Colors
                                                        .black87),
                                              ),
                                              if (cmt.email !=
                                                  null &&
                                                  cmt.email!
                                                      .isNotEmpty)
                                                Text(
                                                  cmt.email!,
                                                  style:
                                                  TextStyle(
                                                    fontSize: 11,
                                                    color: Colors
                                                        .grey
                                                        .shade600,
                                                    fontStyle:
                                                    FontStyle
                                                        .italic,
                                                  ),
                                                ),
                                              SizedBox(height: 6),
                                              Text(
                                                cmt.body ??
                                                    "Không có nội dung",
                                                style: TextStyle(
                                                    color: Colors
                                                        .black54),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    ),
                                  ),

                                // Hiển thị nút PUT / DELETE khi chọn
                                if (isSelected)
                                  Padding(
                                    padding:
                                    EdgeInsets.only(bottom: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: _buildButton(
                                            label: "PUT",
                                            color: Colors.purple,
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    UpdatePostDialogForm(
                                                      controller: widget
                                                          .controller,
                                                      post: selectedPost!,
                                                      onSuccess:
                                                          () async {
                                                        await _loadInitialPosts();
                                                        setState(() {
                                                          selectedPost =
                                                          null;
                                                        });
                                                      },
                                                    ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: _buildButton(
                                            label: "DELETE",
                                            color: Colors.red,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    DeletePostDialogForm(
                                                      controller: widget
                                                          .controller,
                                                      post: selectedPost!,
                                                      onSuccess:
                                                          () async {
                                                        await _loadInitialPosts();
                                                        setState(() {
                                                          selectedPost =
                                                          null;
                                                        });
                                                      },
                                                    ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
          backgroundColor: Colors.transparent),
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
