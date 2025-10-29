import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'labeled_text_field.dart';

class AddTodoDialog extends StatefulWidget {
  final DateTime createdAt;

  const AddTodoDialog({super.key, required this.createdAt});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dueDateController = TextEditingController();

  String _title = '';
  String _description = '';
  Priority _selectedPriority = Priority.Medium;
  DateTime? _dueDate;
  DateTime? _createdAt;

  @override
  void dispose() {
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.createdAt,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDateController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
        _dueDate = pickedDate;
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final confirmed = await _showConfirmationDialog();
      if (confirmed == true) {
        final newTodo = Todo(
          title: _title,
          description: _description,
          priority: _selectedPriority,
          dueDate: _dueDate!,
          createdAt: _createdAt,
        );
        if (mounted) {
          Navigator.pop(context, newTodo);
        }
      }
    }
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận'),
          content: Text('Bạn có chắc muốn thêm công việc này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Có'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Hãy thêm công việc mới'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: 'Tiêu đề',
                required: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập tiêu đề' : null,
                onChanged: (value) => _title = value,
              ),
              const SizedBox(height: 10),

              LabeledTextField(
                validator: (value) =>
                _dueDate == null ? 'vui lòng nhập mô tả' : null,
                label: 'Mô tả',
                required: true,
                onChanged: (value) => _description = value,
              ),
              const SizedBox(height: 10),

              PopupMenuButton<Priority>(
                initialValue: _selectedPriority,
                onSelected: (p) => setState(() => _selectedPriority = p),
                itemBuilder: (context) {
                  return Priority.values.map((p) {
                    return PopupMenuItem<Priority>(
                      value: p,
                      child: Text(p.name),
                    );
                  }).toList();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedPriority.name,
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                validator: (value) =>
                _dueDate == null ? 'vui lòng nhập ngày hết hạn' : null,
                decoration: InputDecoration(
                  labelText: _dueDate == null
                      ? 'Ngày hết hạn *'
                      : 'Ngày hết hạn: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                  helperText: 'Ngày hết hạn phải sau ngày tạo',
                  helperStyle: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                onTap: _selectDueDate,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Hủy')),
        ElevatedButton(onPressed: _handleSave, child: Text('Lưu')),
      ],
    );
  }
}
