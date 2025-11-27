import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../app/controllers/home_controller.dart';
import '../../app/models/requests/create_todo_request.dart';

class CreateToDoForm extends NyStatefulWidget {
  final HomeController controller; // Có thể null nếu xử lý logic tại đây
  final VoidCallback onSuccess;

  CreateToDoForm({
    Key? key,
    required this.controller,
    required this.onSuccess,
  }) : super(key: key, child: _CreateToDoFormState());
}
class _CreateToDoFormState extends NyState<CreateToDoForm> {
  final FocusNode _titleFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedPriority ;
  String? _selectedCategory;
  DateTime _dueDate = DateTime.now().add(Duration(days: 1));

  bool _isLoading = false;

  final List<String> _priorities = ['low', 'medium', 'high'];
  final List<String> _categories = [
    'Work',
    'Personal',
    'Shopping',
    'Health',
    'Study',
    'Other',
    'Life'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate),
      );

      if (time != null) {
        setState(() {
          _dueDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _createTodo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = CreateTodoRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority?.toLowerCase(),
      dueDate: _dueDate,
      category: _selectedCategory,
      completed: false,
    );

    final success = await widget.controller.createNewTodo(
      title: request.title,
      description: request.description,
      priority: request.priority ?? 'medium',
      dueDate: request.dueDate,
      category: request.category,
      completed: request.completed ?? false,
    );

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Tạo todo thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Tạo todo thất bại!'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            child: Text('Có', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();

    // Delay 1 chút để dialog build xong rồi mới focus được
    Future.delayed(Duration(milliseconds: 150), () {
      _titleFocusNode.requestFocus();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.add_task, color: Colors.green, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'Tạo Todo Mới',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        final confirmed = await _showConfirmDialog(
                          'Hủy tạo Todo',
                          'Bạn có chắc muón hủy Totdo đang tạo'
                        );
                        if(confirmed == true){
                          Navigator.pop(context);
                        }
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Divider(height: 24),
                TextFormField(
                  focusNode: _titleFocusNode,
                  controller: _titleController,
                  decoration: InputDecoration(
                    label: buildLabel("Tiêu đề", required: true),
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng không để trống tiêu đề';
                    }
                    if (value.trim().length < 3) {
                      return "Tiêu dề it nhất 3 kí tự";
                    }
                    return null;
                  },
                  maxLength: 100,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    label: buildLabel("Mô tả ", required: true),
                    hintText: 'Nhập mo tả chi tiết',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),
                SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _selectedPriority,
                  decoration: InputDecoration(
                    label: buildLabel("Độ ưu tiên", required: true),
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _priorities.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          _getPriorityIcon(priority),
                          SizedBox(width: 8),
                          Text(priority[0].toUpperCase() + priority.substring(1)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPriority = value!);
                  },
                  validator: (value) =>
                  value == null ? 'Vui lòng chọn độ ưu tiên' : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    label: buildLabel("Danh mục ", required: true),
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          _getCategoryIcon(category),
                          SizedBox(width: 8),
                          Text(category),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value!);
                  },
                  validator: (value) =>
                  value == null ? 'Vui lòng chọn danh mục' : null,
                ),
                SizedBox(height: 16),

                InkWell(
                  onTap: _selectDueDate,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hạn hoàn thành',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _formatDateTime(_dueDate),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Hủy', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createTodo,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Tạo Todo",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPriorityIcon(String priority) {
    Color color;
    switch (priority) {
      case 'high':
        color = Colors.red;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    return Icon(Icons.flag, color: color, size: 20);
  }

  Widget buildLabel(String text, {bool required = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        if (required)
          Text(
            " *",
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }


  Widget _getCategoryIcon(String category) {
    IconData icon;
    switch (category.toLowerCase()) {
      case 'work':
        icon = Icons.work;
        break;
      case 'personal':
        icon = Icons.person;
        break;
      case 'shopping':
        icon = Icons.shopping_cart;
        break;
      case 'health':
        icon = Icons.favorite;
        break;
      case 'study':
        icon = Icons.school;
        break;
      default:
        icon = Icons.task;
    }
    return Icon(icon, size: 20);
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year - $hour:$minute';
  }
}
