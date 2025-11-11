import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '../controllers/http_methods_controller.dart';
import '../models/post.dart';
import '/resources/widgets/buttons/buttons.dart';


class DeletePostDialogForm extends StatelessWidget {
  final HttpMethodsController controller;
  final Post post;
  final VoidCallback onSuccess;

  const DeletePostDialogForm({
    super.key,
    required this.controller,
    required this.post,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Xác nhận xóa',
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bạn có chắc muốn xóa post này?'),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Post #${post.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900)),
                SizedBox(height: 4),
                Text(
                post.title ?? 'Khômg có tiêu đề',
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey),),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
            Navigator.pop(context);
            final success = await controller.deleteMethod(postId: post.id!);
            if (success) onSuccess();
            },
            child: Text('Xóa', style: TextStyle(color: Colors.white
            ),))
      ],
    );
  }
}
