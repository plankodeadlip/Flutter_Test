import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/priority_helper.dart';
import 'delete_confirmation_dialog.dart';
import 'edit_to_do_dialog.dart';

class TodoListItem extends StatefulWidget {
  final Todo todo;
  final VoidCallback onToggleCompleted;
  final VoidCallback onDelete;
  final Function(Todo) onUpdate;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.onToggleCompleted,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  bool isExpanded = false; // 👈 biến để mở rộng mô tả

  Future<void> _handleCheckboxChange(BuildContext context, bool? value) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: Text(
            value == true
                ? 'Bạn có chắc muốn đánh dấu công việc này là Done?'
                : 'Bạn có chắc muốn đánh dấu công việc này là Not Done?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Có'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      widget.onToggleCompleted();
    }
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteConfirmationDialog(),
    );

    if (confirmed == true) {
      widget.onDelete();
    }
  }

  Future<void> _handleTap(BuildContext context) async {
    final wantToEdit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác Nhận'),
          content: const Text('Bạn có muốn chỉnh sửa công việc này không'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Không'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Có'),
            ),
          ],
        );
      },
    );

    if (wantToEdit == true) {
      final updatedTodo = await showDialog<Todo>(
        context: context,
        builder: (context) => editToDoDialog(toDo: widget.todo),
      );

      if (updatedTodo != null) {
        widget.onUpdate(updatedTodo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    const int maxChars = 25;
    bool isLong = todo.description.length > 20;
    String displayText;

    if (isExpanded) {
      // nếu mở rộng, hiển thị toàn bộ mô tả (ngắt dòng mỗi 20 ký tự)
      final buffer = StringBuffer();
      for (int i = 0; i < todo.description.length; i += maxChars) {
        int end = (i + maxChars < todo.description.length)
            ? i + maxChars
            : todo.description.length;
        buffer.writeln(todo.description.substring(i, end));
      }
      displayText = buffer.toString();
    } else {
      displayText = isLong
          ? todo.description.substring(0, 20) + '...'
          : todo.description;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: ListTile(
        onTap: () => _handleTap(context),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) => _handleCheckboxChange(context, value),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: todo.isCompleted ? Colors.grey : Colors.blue,
              ),
            ),
            const Spacer(),
            Text(
              'Hạn: ${todo.dueDate.day}/${todo.dueDate.month}/${todo.dueDate.year}',
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayText,
              style: const TextStyle(color: Colors.black87),
            ),
            if (isLong)
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Ẩn' : 'Thêm',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tạo: ${todo.createdAt.day}/${todo.createdAt.month}/${todo.createdAt.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: PriorityHelper.getColor(todo.priority)),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () => _handleDelete(context),
            ),
          ],
        ),
      ),
    );
  }
}
