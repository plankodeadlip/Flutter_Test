import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/todo.dart';
import '../widgets/listSection.dart';
import '../widgets/todo_list_item.dart';
import '../widgets/add_todo_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<Todo> _toDo = [
    Todo(
      title: 'Học việc',
      description: 'Học việc thôi',
      priority: Priority.High,
      createdAt: DateTime(2025, 10, 20, 14, 30),
      dueDate: DateTime(2025, 11, 27, 00, 00),
    ),
    Todo(
      title: 'Học việc 2',
      description: 'Học việc thôi 2',
      priority: Priority.High,
      dueDate: DateTime(2025, 11, 20, 00, 00),
    ),
  ];
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String onActiveTab = 'notDone';
  String sortOption = 'Mới nhất';

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }


  void _toggleCompleted(Todo todo) {
    setState(() {
      todo.toggleCompleted();
    });
    _saveToDoList();
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _toDo.remove(todo);
    });
    _saveToDoList();
  }

  void _updateTodo(Todo oldTodo, Todo updatedTodo) {
    setState(() {
      final index = _toDo.indexOf(oldTodo);
      if (index != -1) {
        _toDo[index] = updatedTodo;
      }
      sortToDo();
    });
    _saveToDoList();
  }

  void _addToDo() async {
    final newTodo = await showDialog<Todo>(
      context: context,
      builder: (context) => AddTodoDialog(createdAt: DateTime.now()),
    );

    if (newTodo != null) {
      setState(() {
        _toDo.add(newTodo);
        sortToDo();
      });
      _saveToDoList();
    }
  }

  void sortToDo() {
    setState(() {
      switch (sortOption) {
        case 'Mới nhất':
          _toDo.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'Cũ nhất':
          _toDo.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case 'Mức ưu tiên cao -> thấp':
          _toDo.sort((a, b) => b.priority.index.compareTo(a.priority.index));
          break;
        case 'Tên (A-Z)':
          _toDo.sort((a, b) => a.title.compareTo(b.title));
          break;
      }
    });
  }

  Future<void> _saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
    _toDo.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todo_list', jsonList);
  }

  Future<void> _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('todo_list');
    if (jsonList != null) {
      setState(() {
        _toDo = jsonList
            .map((item) => Todo.fromJson(jsonDecode(item)))
            .toList();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final filteredList = _toDo.where((t) {
      final matchesTab = switch (onActiveTab) {
        'all' => true,
        'done' => t.isCompleted,
        _ => !t.isCompleted,
      };

      final matchesSearch =
          t.title.toLowerCase().contains(searchQuery) ||
          t.description.toLowerCase().contains(searchQuery) ||
          t.createdAt.toString().toLowerCase().contains(searchQuery) ||
          t.dueDate.toString().toLowerCase().contains(searchQuery);

      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'TranHung To Do List',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.activeBlue,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: listSection(toDo: _toDo)),

            SliverToBoxAdapter(child: _buildFilterButtons()),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final todo = filteredList[index];
                  return TodoListItem(
                    todo: todo,
                    onToggleCompleted: () => _toggleCompleted(todo),
                    onDelete: () => _deleteTodo(todo),
                    onUpdate: (updatedTodo) => _updateTodo(todo, updatedTodo),
                  );
                },
                childCount: filteredList.length
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 80,),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToDo,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 Thanh tìm kiếm
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm công việc...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 🔘 Bộ lọc trạng thái
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 5,
            children: [
              _buildFilterButton(
                label: 'Not Done',
                isActive: onActiveTab == 'notDone',
                onPressed: () => setState(() {
                  onActiveTab = 'notDone';
                }),
              ),
              _buildFilterButton(
                label: 'All',
                isActive: onActiveTab == 'all',
                onPressed: () => setState(() {
                  onActiveTab = 'all';
                }),
              ),
              _buildFilterButton(
                label: 'Done',
                isActive: onActiveTab == 'done',
                onPressed: () => setState(() {
                  onActiveTab = 'done';
                }),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🧭 Dropdown sắp xếp
          // Trong _buildFilterButtons(), thay thế phần Row chứa DropdownButton
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.sort, color: CupertinoColors.activeBlue),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                initialValue: sortOption,
                onSelected: (value) {
                  setState(() {
                    sortOption = value;
                    sortToDo();
                  });
                },
                itemBuilder: (context) {
                  return [
                    'Mới nhất',
                    'Cũ nhất',
                    'Mức ưu tiên cao → thấp',
                    'Tên (A-Z)',
                  ].map((option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      sortOption,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(width: 5),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    Color getButtonColor() {
      if (!isActive) return CupertinoColors.inactiveGray;

      if (onActiveTab == 'notDone') return CupertinoColors.destructiveRed;
      if (onActiveTab == 'all') return CupertinoColors.activeBlue;
      if (onActiveTab == 'done') return CupertinoColors.activeGreen;

      return CupertinoColors.activeBlue;
    }

    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: getButtonColor(),
          ),
        ),
      ),
    );
  }
}
