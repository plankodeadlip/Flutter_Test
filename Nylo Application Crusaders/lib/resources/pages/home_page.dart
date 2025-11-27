import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:provider/provider.dart';
import '../../app/networking/api_service.dart';
import '../../app/utils/enum.dart';
import '../widgets/create_to_do_form_widget.dart';
import '../widgets/expand_todo_widget.dart';
import '../widgets/update_to_do_form_widget.dart';
import '/app/controllers/home_controller.dart';
import '/app/models/todo.dart';
import '/app/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends NyPage<HomePage> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();
  ApiService api = ApiService();

  List<Todo> _todos = []; // raw list (from last API fetch)
  List<Todo> _filteredTodos = []; // displayed list (depends on current mode)

  String _activeTab = 'all'; // status filter: "all", "pending", "completed"
  String _filterMode = 'all'; // filter mode: "all", "overdue", "alphabet", "recent", "priority", "category"
  String _selectedFilterLabel = 'Tất cả';

  bool _isLoading = false;
  bool _isRefreshing = false;

  String _searchQuery = '';
  bool searchHasMore = true;
  bool isSearchLoadingMore = false;
  bool isLoadingMore = false;
  int searchPage = 1;
  int currentPage = 1;
  bool isHasMore = false;

  // Tổng số liệu từ API
  int _totalTodosCount = 0;
  int _completedTodosCount = 0;

  Timer? _debounce;
  Set<String> expandedTodos = {};

  String? _selectedPriority; // null, low, medium, high
  String _selectedCategory = '';
  final List<String> _availableCategories = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Study',
    'Other',
  ];

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;

      if (authProvider.errorMessage != null) {
        _showSnackBar(authProvider.errorMessage!, isError: true);
      } else if (user != null) {
        _showSnackBar('Xin chào ${user.username}! 👋', isError: false);
      }

      _scrollController.addListener(_onScroll);

      // Initial load: unfiltered list
      await loadTodos();

      // Load totals for progress bar and counts
      await _loadTotalCount();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Lấy tổng số todo + completed từ API
  Future<void> _loadTotalCount() async {
    try {
      final count = await api.getTodosCount();
      final completedCount = await api.getCompletedTodosCount();
      if (!mounted) return;
      setState(() {
        _totalTodosCount = count;
        _completedTodosCount = completedCount;
      });
    } catch (e) {
      NyLogger.error("❌ _loadTotalCount error: $e");
    }
  }

  Widget _filterPopupMenu() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.blue, size: 20,),
          SizedBox(width: 8,),
          Text(
            'Filter',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700
            ),
          ),
          Expanded(
              child: PopupMenuButton<String>(
                  initialValue: _filterMode,
                  onSelected: (value) async{
                    setState(() {
                      _filterMode = value;
                      _selectedFilterLabel = _getFilterLabel(value);

                      if(value != 'priority') _selectedPriority = null;
                      if(value != 'category') _selectedCategory = '';

                      currentPage = 1;
                      isHasMore = true;
                      _todos.clear();
                      _filteredTodos.clear();
                    });
                    await _applyFilter();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Text(
                              _selectedFilterLabel,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    _buildPopupMenuItem('all', 'Tất cả', Icons.list),
                    _buildPopupMenuItem('overdue', 'Quá hạn', Icons.warning_amber),
                    _buildPopupMenuItem('alphabet', 'A-Z', Icons.sort_by_alpha),
                    _buildPopupMenuItem('recent', 'Gần đây', Icons.access_time),
                    _buildPopupMenuItem('priority', 'Ưu tiên', Icons.flag),
                    _buildPopupMenuItem('category', 'Danh mục', Icons.category),
                    _buildPopupMenuItem('dueDate', 'Hạn chót', Icons.calendar_today),
                  ]
              )
          ),


          // Priority Sub-Menu (chỉ hiện khi chọn priority)
          if (_filterMode == 'priority') ...[
            SizedBox(width: 8),
            PopupMenuButton<String>(
              initialValue: _selectedPriority,
              onSelected: (value) async {
                setState(() {
                  _selectedPriority = value;
                  currentPage = 1;
                  _todos.clear();
                  _filteredTodos.clear();
                });
                await _applyFilter();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: _getPriorityColor(_selectedPriority).withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _getPriorityColor(_selectedPriority),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.flag,
                      size: 16,
                      color: _getPriorityColor(_selectedPriority),
                    ),
                    SizedBox(width: 4),
                    Text(
                      _selectedPriority?.toUpperCase() ?? 'Tất cả',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _getPriorityColor(_selectedPriority),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 16,
                      color: _getPriorityColor(_selectedPriority),
                    ),
                  ],
                ),
              ),
              itemBuilder: (context) => [
                _buildPriorityMenuItem(null, 'Tất cả'),
                _buildPriorityMenuItem('low', 'Thấp'),
                _buildPriorityMenuItem('medium', 'Trung bình'),
                _buildPriorityMenuItem('high', 'Cao'),
              ],
            ),
          ],

          if (_filterMode == 'category') ...[
            SizedBox(width: 8),
            PopupMenuButton<String>(
              initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
                onSelected: (value) async{
                setState(() {
                  _selectedCategory=value;
                  currentPage = 1;
                  _todos.clear();
                  _filteredTodos.clear();
                });
                await _applyFilter();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.purple.shade300, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(_selectedCategory),
                        size: 16,
                        color: Colors.purple.shade700,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _selectedCategory.isEmpty ? 'Tất cả' : _selectedCategory,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 16,
                        color: Colors.purple.shade700,
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context) =>[
                  _buildCategoryMenuItem('', 'Tất cả', Icons.all_inclusive),
                  ..._availableCategories.map(
                        (cat) => _buildCategoryMenuItem(
                      cat,
                      cat,
                      _getCategoryIcon(cat),
                    ),
                  ),
                ]
            )
          ]
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String label, IconData icon) {
    final isSelected = _filterMode == value;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.black87,
            ),
          ),
          if (isSelected) ...[
            Spacer(),
            Icon(Icons.check, size: 18, color: Colors.blue),
          ],
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPriorityMenuItem(String? value, String label) {
    final isSelected = _selectedPriority == value;
    final color = _getPriorityColor(value);

    return PopupMenuItem<String>(
      value: value ?? '',
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : Colors.black87,
            ),
          ),
          if (isSelected) ...[
            Spacer(),
            Icon(Icons.check, size: 18, color: color),
          ],
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildCategoryMenuItem(String value, String label, IconData icon) {
    final isSelected = _selectedCategory == value;

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.purple : Colors.grey,
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.purple : Colors.black87,
            ),
          ),
          if (isSelected) ...[
            Spacer(),
            Icon(Icons.check, size: 18, color: Colors.purple),
          ],
        ],
      ),
    );
  }

  // Áp filter -> gọi API getFilteredTodos
  Future<void> _applyFilter() async {
    setState(() {
      _isLoading = true;
    });

    // ================= OVERDUE FILTER (LOCAL) =================
    if (_filterMode == 'overdue') {
      setState(() {
        _todos.clear();
        _filteredTodos.clear();
      });

      try {
        // Lấy nhiều để đảm bảo lọc đủ
        final response = await api.getAllTodos(page: 1, limit: 200);

        if (response == null || response.data == null) {
          setState(() => _isLoading = false);
          return;
        }

        final allTodos = response.data!.todos ?? [];
        final now = DateTime.now();

        final overdueTodos = allTodos.where((t) =>
        t.completed == false &&
            t.dueDate != null &&
            t.dueDate!.isBefore(now)
        ).toList();

        setState(() {
          _todos = overdueTodos;
          _filteredTodos = overdueTodos;
          isHasMore = false; // overdue không phân trang
          currentPage = 1;
          _isLoading = false;
        });

        return; // DỪNG TẠI ĐÂY!!!
      } catch (e) {
        print("Error filtering overdue: $e");
        setState(() => _isLoading = false);
        return;
      }
    }

    // ============== FILTER KHÁC (API) ==================
    try {
      TodoPriority? priorityEnum;
      if (_selectedPriority != null && _selectedPriority!.isNotEmpty) {
        priorityEnum = TodoPriority.fromString(_selectedPriority);
      }

      final response = await api.getFilteredTodos(
        page: currentPage,
        limit: 10,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery.trim() : null,
        status: _activeTab,
        filterMode: _filterMode,
        priority: priorityEnum,
        category: _selectedCategory.isNotEmpty ? _selectedCategory : null,
      );

      if (!mounted) return;

      if (response != null && response.data != null) {
        final todos = response.data!.todos ?? [];

        setState(() {
          if (currentPage == 1) {
            _todos = todos;
          } else {
            _todos.addAll(todos);
          }
          _filteredTodos = _todos;
          isHasMore = response.data!.pagination.hasNextPage;
          currentPage++;
          _isLoading = false;
        });
      } else {
        print("❌ Response null hoặc không có data");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      NyLogger.error("❌ _applyFilter error: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  // Search (your existing flow) — uses separate API endpoint
  Future<void> _performSearch(String value) async {
    value = value.trim();

    if (value.isEmpty) {
      // Cancel search -> back to current filter / list
      setState(() {
        _searchQuery = '';
        isSearchLoadingMore = false;
        isLoadingMore = false;
        searchHasMore = true;
        searchPage = 1;
      });

      // Reload according to current state: if there's an active filter -> apply it
      if (_filterMode != 'all' || _activeTab != 'all') {
        currentPage = 1;
        _todos.clear();
        _filteredTodos.clear();
        await _applyFilter();
      } else {
        await loadTodos();
      }
      return;
    }

    setState(() {
      _searchQuery = value;
      isSearchLoadingMore = true;
      _isLoading = true;
      searchPage = 1;
      searchHasMore = true;
      _todos.clear();
      _filteredTodos.clear();
    });

    try {
      final response = await api.searchTodos(query: value, page: searchPage, limit: 10);
      if (!mounted) return;

      if (response != null && response.data != null) {
        setState(() {
          _todos = response.data.todos;
          _filteredTodos = _todos;
          searchHasMore = response.data.pagination.hasNextPage;
          searchPage++;
          _isLoading = false;
        });
        NyLogger.info("🔍 Search '$value': Found ${_todos.length} results");
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      NyLogger.error("❌ Search error: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_searchQuery.isNotEmpty) {
        if (searchHasMore && !isLoadingMore) loadMore();
      } else {
        if (isHasMore && !isLoadingMore) loadMore();
      }
    }
  }

  // Initial load (unfiltered)
  Future<void> loadTodos() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
      _isLoading = true;
      currentPage = 1;
    });

    try {
      final response = await api.getAllTodos(page: currentPage, limit: 10);

      if (!mounted) return;

      if (response != null && response.data != null) {
        setState(() {
          _todos = response.data.todos;
          _filteredTodos = _todos;
          isHasMore = response.data.pagination.hasNextPage;
          currentPage++;
          isLoadingMore = false;
          _isLoading = false;
        });
      }

      // Update totals
      await _loadTotalCount();
    } catch (e) {
      NyLogger.error("❌ loadTodos error: $e");
      if (!mounted) return;

    } finally {
      setState(() {
        isLoadingMore = false;
        _isLoading = false;
      });
    }
  }

  // Load more respects current mode: search -> searchTodos, filter -> getFilteredTodos, otherwise getTodos
  Future<void> loadMore() async {
    if (isLoadingMore) return;

    setState(() => isLoadingMore = true);

    try {
      dynamic response;

      if (_searchQuery.isNotEmpty) {
        response = await api.searchTodos(query: _searchQuery.trim(), page: searchPage, limit: 10);
      } else if (_filterMode != 'all' || _activeTab != 'all') {
        response = await api.getFilteredTodos(
          page: currentPage,
          limit: 10,
          searchQuery: _searchQuery,
          status: _activeTab,
          filterMode: _filterMode,
        );
        response = await api.getAllTodos(page: currentPage, limit: 10);
      }

      if (!mounted) return;

      if (response != null && response.data != null) {
        final newTodos = response.data.todos ?? [];

        setState(() {
          if (_searchQuery.isNotEmpty) {
            _todos.addAll(newTodos);
            _filteredTodos = _todos;
            searchHasMore = response.data.pagination.hasNextPage;
            searchPage++;
          } else {
            _todos.addAll(newTodos);
            _filteredTodos = _todos;
            isHasMore = response.data.pagination.hasNextPage;
            currentPage++;
          }
          isLoadingMore = false;
        });
      } else {
        setState(() => isLoadingMore = false);
      }
    } catch (e) {
      NyLogger.error("❌ loadMore error: $e");
      if (!mounted) return;
      setState(() => isLoadingMore = false);
    }
  }

  Future<void> _refreshTodos() async {
    setState(() => _isRefreshing = true);

    // Reset pagination and re-load according to mode
    searchPage = 1;
    currentPage = 1;
    searchHasMore = true;
    isHasMore = true;
    _todos.clear();
    _filteredTodos.clear();

    if (_searchQuery.isNotEmpty) {
      await _performSearch(_searchQuery);
    } else if (_filterMode != 'all' || _activeTab != 'all') {
      await _applyFilter();
    } else {
      await loadTodos();
    }

    await _loadTotalCount();

    if (!mounted) return;
    setState(() => _isRefreshing = false);
  }

  void _showTodoActions(Todo todo) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text("Sửa Todo"),
                onTap: () async {
                  Navigator.pop(context);
                  _openEditTodoForm(todo);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Xóa Todo"),
                onTap: () async {
                  Navigator.pop(context);
                  _deleteTodo(todo);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openEditTodoForm(Todo todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: UpdateTodoDialogForm(
            controller: _controller,
            todo: todo,
            onSuccess: () async {
              if (_searchQuery.isNotEmpty) {
                await _performSearch(_searchQuery);
              } else if (_filterMode != 'all' || _activeTab != 'all') {
                currentPage = 1;
                _todos.clear();
                _filteredTodos.clear();
                await _applyFilter();
              } else {
                await loadTodos();
              }
              await _loadTotalCount();
            },
          ),
        );
      },
    );
  }


  Future<void> _toggleTodo(Todo todo) async {
    final confirmed = await _showConfirmDialog(
      'Chuyển trạng thái của Todo',
      'Bạn có chắc muốn chuyển trạng thái của "${todo.title}"?',
    );

    if (confirmed == true) {
      final toggled = await todo.toggleCompleted();
      if (toggled != null) {
        // Update local displayed lists (best-effort) and then refresh totals
        setState(() {
          final index = _todos.indexWhere((t) => t.id == todo.id);
          if (index != -1) _todos[index] = toggled;
          _filteredTodos = _todos;
        });
        _showSnackBar(
          toggled.completed ? 'Đã hoàn thành ✅' : 'Đánh dấu chưa xong ⏳',
        );
      }
      await _loadTotalCount();
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    final confirmed = await _showConfirmDialog(
      'Xóa Todo',
      'Bạn có chắc muốn xóa "${todo.title}"?',
    );

    if (confirmed == true) {
      final deleted = await todo.delete();
      if (deleted) {
        setState(() {
          _todos.removeWhere((t) => t.id == todo.id);
          _filteredTodos = _todos;
        });
        _showSnackBar('Đã xóa todo');
        await _loadTotalCount();
      } else {
        _showSnackBar('Không thể xóa todo', isError: true);
      }
    }
  }

  String formatDateTime(DateTime? date) {
    if (date != null) {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return '$day/$month/$year - $hour:$minute';
    } else
      return '';
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Có',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Completion %
  double get completionPercentage {
    if (_totalTodosCount == 0) return 0.0;
    return (_completedTodosCount / _totalTodosCount) * 100;
  }

  Widget _processBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${completionPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: completionPercentage / 100,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completionPercentage >= 100
                          ? Colors.green
                          : completionPercentage >= 75
                          ? Colors.blue
                          : completionPercentage >= 50
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Icon(CupertinoIcons.doc, color: Colors.grey.shade700),
              SizedBox(width: 4),
              Text(
                '$_totalTodosCount',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    // Compute counts for the small status tabs using totals from API
    final total = _totalTodosCount;
    final completed = _completedTodosCount;
    final pending = (total - completed).clamp(0, total);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Xin chào, ${user?.username ?? 'Guest'}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshTodos,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await _showConfirmDialog(
                'Đăng xuất',
                'Bạn có chắc muốn đăng xuất?',
              );
              if (confirmed == true) {
                authProvider.logout();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTodos,
        child: CustomScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(child: _processBar()),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                child: SearchBar(
                  controller: _searchController,
                  hintText: "Tìm kiếm công việc...",
                  leading: _isLoading && _searchQuery.isNotEmpty
                      ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(Icons.search, color: Colors.grey),
                  trailing: _searchQuery.isNotEmpty
                      ? [
                    IconButton(
                      onPressed: () async {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          isSearchLoadingMore = false;
                        });
                        // back to filter / unfiltered list
                        if (_filterMode != 'all' || _activeTab != 'all') {
                          currentPage = 1;
                          _todos.clear();
                          _filteredTodos.clear();
                          await _applyFilter();
                        } else {
                          await loadTodos();
                        }
                      },
                      icon: Icon(Icons.clear, color: Colors.grey),
                    ),
                  ]
                      : null,
                  backgroundColor: WidgetStatePropertyAll(Colors.white),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  elevation: WidgetStatePropertyAll(1),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(Duration(milliseconds: 500), () async {
                      await _performSearch(value);
                    });
                  },
                ),
              ),
            ),

            // Filter modes (TabBar) - normal (cuộn cùng content)
            SliverToBoxAdapter(child: _filterPopupMenu()),

            // Status small tabs (All / Pending / Completed)
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _buildStatusTab('Tất cả', 'all', total),
                    _buildStatusTab('Chưa xong', 'pending', pending),
                    _buildStatusTab('Hoàn thành', 'completed', completed),
                  ],
                ),
              ),
            ),

            // Todo List
            _isLoading
                ? SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                : _filteredTodos.isEmpty
                ? SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      _searchQuery.isEmpty ? 'Không có công việc nào' : 'Không tìm thấy kết quả',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
                : SliverPadding(
              padding: EdgeInsets.all(8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    // show loading indicator at the end
                    if (index == _filteredTodos.length) {
                      return isLoadingMore
                          ? Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : SizedBox.shrink();
                    }

                    final todo = _filteredTodos[index];
                    return _buildTodoCard(todo);
                  },
                  childCount: _filteredTodos.length + (isLoadingMore ? 1 : 0),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return CreateToDoForm(
                controller: _controller,
                onSuccess: () async {
                  // After create -> reload current view
                  if (_searchQuery.isNotEmpty) {
                    await _performSearch(_searchQuery);
                  } else if (_filterMode != 'all' || _activeTab != 'all') {
                    currentPage = 1;
                    _todos.clear();
                    _filteredTodos.clear();
                    await _applyFilter();
                  } else {
                    await loadTodos();
                  }
                  await _loadTotalCount();
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusTab(String label, String value, int count) {
    final isActive = _activeTab == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeTab = value;
            // reset and apply filter via API
            currentPage = 1;
            isHasMore = true;
            _todos.clear();
            _filteredTodos.clear();
          });
          _applyFilter();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: isActive ? Colors.blue : Colors.transparent, width: 3),
            ),
          ),
          child: Center(
            child: Text(
              '$label ($count)',
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodoCard(Todo todo) {
    final isExpanded = expandedTodos.contains(todo.id);
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: isExpanded ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isExpanded ? BorderSide(color: Colors.blue, width: 2) : BorderSide.none,
      ),
      child: Column(
        children: [
          ListTile(
            onLongPress: () => _showTodoActions(todo),
            leading: Checkbox(
              value: todo.completed,
              onChanged: (_) {
                _toggleTodo(todo);
              },
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.completed ? TextDecoration.lineThrough : TextDecoration.none,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todo.description.isNotEmpty && !isExpanded) ...[
                  SizedBox(height: 4),
                  Text(
                    todo.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: todo.priorityColor.withValues(alpha:0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        todo.priority.name[0].toUpperCase() + todo.priority.name.substring(1),
                        style: TextStyle(
                          color: todo.priorityColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(todo.categoryIcon, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(todo.category, style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Spacer(),
                    Text(
                      todo.formattedDueDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: todo.isOverdue ? Colors.red : Colors.grey,
                        fontWeight: todo.isOverdue ? FontWeight.bold : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  expandedTodos.remove(todo.id);
                } else {
                  expandedTodos.add(todo.id);
                }
              });
            },
          ),
          if (isExpanded) ExpandTodo(todo: todo),
        ],
      ),
    );
  }

  String _getFilterLabel(String filterMode) {
    switch (filterMode) {
      case 'all':
        return 'Tất cả';
      case 'overdue':
        return 'Quá hạn';
      case 'alphabet':
        return 'A-Z';
      case 'recent':
        return 'Gần đây';
      case 'priority':
        return 'Ưu tiên';
      case 'category':
        return 'Danh mục';
      case 'dueDate':
        return 'Hạn chót';
      default:
        return 'Tất cả';
    }
  }

  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.work;
      case 'personal':
        return Icons.person;
      case 'shopping':
        return Icons.shopping_cart;
      case 'health':
        return Icons.favorite;
      case 'study':
        return Icons.school;
      case 'other':
        return Icons.more_horiz;
      default:
        return Icons.all_inclusive;
    }
  }
}
