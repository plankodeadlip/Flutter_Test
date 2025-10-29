import 'package:flutter/material.dart';
import '../models/todo.dart';

class editToDoDialog extends StatefulWidget {
  final Todo toDo;

  const editToDoDialog({super.key, required this.toDo});

  @override
  State<editToDoDialog> createState() => _editToDoDialogState();
}

class _editToDoDialogState extends State<editToDoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dueDateController = TextEditingController();

  late String _title;
  late String _description;
  late Priority _selectedPriority;
  late DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _title = widget.toDo.title;
    _description = widget.toDo.description;
    _selectedPriority = widget.toDo.priority;
    _dueDate = widget.toDo.dueDate;

    if (_dueDate != null) {
      _dueDateController.text =
          '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}';
    }
  }

  @override
  void dispose() {
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _selectedDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: widget.toDo.createdAt, // Không được chọn ngày trước createdAt
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
        _dueDateController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final confirmed = await _showConfirmationDialog();
      if (confirmed == true) {
        widget.toDo.title = _title;
        widget.toDo.description = _description;
        widget.toDo.priority = _selectedPriority;
        widget.toDo.dueDate = _dueDate!;
        if (mounted) {
          Navigator.pop(context, widget.toDo); // Trả về todo đã được cập nhật
        }
      }
    }
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text('Xác Nhận'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bạn có chắc muốn thay đổi công việc này không',
                style: TextStyle(fontSize: 26),
              ),
              Text(
                'Việc thay đổi dữ liệu của To Do List này không thể phục hồi',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Đồng ý'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chỉnh sửa công việc'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  label: RichText(
                    text: TextSpan(
                      text: 'Tiêu đề',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  helperStyle: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nhập tiêu đề' : null,
                onChanged: (value) => _title = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập mô tả' : null,
                initialValue: _description,
                decoration: InputDecoration(
                  label: RichText(
                    text: TextSpan(
                      text: 'Mô tả',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => _description = value,
              ),
              SizedBox(height: 10),
              PopupMenuButton<Priority>(
                initialValue: _selectedPriority,
                onSelected: (p) {
                  setState(() {
                    _selectedPriority = p;
                  });
                },
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
                      Text(_selectedPriority.name),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _dueDateController,
                readOnly: true,
                validator: (value) =>
                    _dueDate == null ? 'vui lòng nhập ngày hết hạn' : null,
                decoration: InputDecoration(
                  labelText: _dueDate == null
                      ? 'Ngày hết hạn *'
                      : 'Ngày hết hạn: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.day}',
                  helperText:
                      'Ngày hết hạn phải sau ngày tạo (${widget.toDo.createdAt.day}/${widget.toDo.createdAt.month}/${widget.toDo.createdAt.year})',
                  helperStyle: TextStyle(fontSize: 10, color: Colors.grey),
                ),
                onTap: _selectedDueDate,
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
