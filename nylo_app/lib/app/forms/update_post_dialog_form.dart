import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '../controllers/http_methods_controller.dart';
import '../models/post.dart';


class UpdatePostDialogForm extends StatelessWidget  {
  final HttpMethodsController controller;
  final Post post;
  final VoidCallback onSuccess;

  const UpdatePostDialogForm({
    super.key,
    required this.controller,
    required this.post,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: post.title);
    final bodyController = TextEditingController(text: post.body);

    return AlertDialog(
      title: Text(
        '✏️ Cập Nhật Post #${post.id}',
        style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title, color: Colors.pink),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description, color: Colors.pink),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () async {
            Navigator.pop(context);

            final newTitle = titleController.text.trim();
            final newBody = bodyController.text.trim();

            final success = await controller.putMethod(
              postId: post.id ?? 0,
              userId: post.userId ?? 1,
              title: newTitle,
              body: newBody,
            );

            if (success) {
              onSuccess();
              NyLogger.info("✅ Đã cập nhật thành công bài viết #${post.id}");
            } else {
              NyLogger.error("❌ Cập nhật thất bại bài viết #${post.id}");
            }
          },
    icon: const Icon(Icons.save, color: Colors.white),
    label: const Text(
    'Cập nhật',
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        )
      ],
    );

  }
}
