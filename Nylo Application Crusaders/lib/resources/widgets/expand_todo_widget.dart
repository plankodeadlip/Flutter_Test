import 'package:flutter/material.dart';
import '../../app/models/todo.dart';

class ExpandTodo extends StatelessWidget {
  final Todo todo;

  const ExpandTodo({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return _buildExpandedDetail(todo);
  }

  Widget _buildExpandedDetail(Todo todo) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          SizedBox(height: 8),

          // FULL DESCRIPTION
          if (todo.description.isNotEmpty) ...[
            _buildDetailRow(
              icon: Icons.description,
              label: 'Mô tả',
              content: todo.description,
              isMultiline: true,
            ),
            SizedBox(height: 12),
          ],

          // STATUS
          _buildDetailRow(
            icon: Icons.check_circle,
            label: 'Trạng thái',
            content: todo.completed ? 'Đã hoàn thành ✅' : 'Chưa hoàn thành ⏳',
            contentColor: todo.completed ? Colors.green : Colors.orange,
          ),
          SizedBox(height: 12),

          // PRIORITY
          _buildDetailRow(
            icon: todo.priorityIcon,
            label: 'Độ ưu tiên',
            content: todo.priority.name[0].toUpperCase()+todo.priority.name.substring(1),
            contentColor: todo.priorityColor,
          ),
          SizedBox(height: 12),

          // CATEGORY
          _buildDetailRow(
            icon: todo.categoryIcon,
            label: 'Danh mục',
            content: todo.category,
          ),
          SizedBox(height: 12),

          // DUE DATE
          _buildDetailRow(
            icon: Icons.calendar_today,
            label: 'Ngày hết hạn',
            content: formatDateTime(todo.dueDate),
            contentColor: todo.isOverdue ? Colors.red : null,
          ),
          SizedBox(height: 12),

          // CREATED AT
          _buildDetailRow(
            icon: Icons.access_time,
            label: 'Ngày tạo',
            content: formatDateTime(todo.createdAt),
          ),

          // UPDATED AT
          if (todo.updateAt != null) ...[
            SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.update,
              label: 'Cập nhật lần cuối',
              content: formatDateTime(todo.updateAt),
            ),
          ],

          // COMPLETED AT
          if (todo.completedAt != null) ...[
            SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.done_all,
              label: 'Hoàn thành lúc',
              content: formatDateTime(todo.completedAt),
              contentColor: Colors.green,
            ),
          ],

          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String content,
    Color? contentColor,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment:
      isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: contentColor ?? Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatDateTime(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year - $hour:$minute';
  }
}
