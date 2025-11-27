import 'package:flutter/material.dart';
import 'package:flutter_app/app/utils/date_utils.dart';
import '/app/controllers/home_controller.dart';
import '/app/models/todo.dart';
import '../../app/models/requests/update_todo_request.dart';
import 'package:nylo_framework/nylo_framework.dart';

class UpdateTodoDialogForm extends NyStatefulWidget {
  final HomeController controller;
  final Todo todo;
  final VoidCallback onSuccess;

  UpdateTodoDialogForm({
    Key? key,
    required this.controller,
    required this.todo,
    required this.onSuccess,
  }) : super(key: key, child: _UpdateTodoDialogFormState());
}

class _UpdateTodoDialogFormState extends NyState<UpdateTodoDialogForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedPriority;
  late String _selectedCategory;
  late DateTime _dueDate;
  late bool _completed;

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
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
    _selectedPriority = widget.todo.priority.name;
    _selectedCategory = widget.todo.category;
    _dueDate = widget.todo.dueDate;
    _completed = widget.todo.completed;
  }

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
      firstDate: DateTime.now().subtract(Duration(days: 365)),
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

  Future<void> _updateTodo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final request = UpdateTodoRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _selectedPriority.toLowerCase(),
      dueDate: _dueDate,
      category: _selectedCategory,
      completed: _completed,
    );

    final success = await widget.todo.update(request);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Cập nhật todo thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Cập nhật todo thất bại!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.edit, color: Colors.purple, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cập Nhật Todo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(height: 24),

                // Completed Checkbox
                CheckboxListTile(
                  title: Text('Đã hoàn thành'),
                  value: _completed,
                  onChanged: (value) {
                    setState(() => _completed = value ?? false);
                  },
                  activeColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                SizedBox(height: 16),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề *',
                    hintText: 'Nhập tiêu đề todo',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tiêu đề';
                    }
                    if (value.trim().length < 3) {
                      return 'Tiêu đề phải có ít nhất 3 ký tự';
                    }
                    return null;
                  },
                  maxLength: 100,
                ),
                SizedBox(height: 16),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    hintText: 'Nhập mô tả chi tiết',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),
                SizedBox(height: 16),

                // Priority Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Độ ưu tiên',
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

                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Danh mục',
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

                // Due Date Picker
                InkWell(
                  onTap: _selectDueDate,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
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
                              DateTimeUtils.formatDateTime(_dueDate),
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

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Hủy',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateTodo,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.purple,
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
                          'Cập Nhật',
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

}