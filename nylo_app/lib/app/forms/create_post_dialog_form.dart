import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '../controllers/http_methods_controller.dart';
import '/resources/widgets/buttons/buttons.dart';

/* CreatePostDialog Form
|--------------------------------------------------------------------------
| Usage: https://nylo.dev/docs/6.x/forms#how-it-works
| Casts: https://nylo.dev/docs/6.x/forms#form-casts
| Validation Rules: https://nylo.dev/docs/6.x/validation#validation-rules
|-------------------------------------------------------------------------- */

class CreatePostDialogForm extends StatelessWidget {

  final HttpMethodsController controller;
  final VoidCallback  onSuccess;

  const CreatePostDialogForm({
    super.key,
    required this.controller,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    return AlertDialog(
      title: Text(
        'Tạo post mới',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đế',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title, color: Colors.blue)
              ),
            ),
            SizedBox(height: 12,),
            TextField(
              controller: bodyController,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description, color: Colors.blue,)
              ),
              maxLines: 4,
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: ()=> Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey),)
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              if (titleController.text.trim().isEmpty) {
                NyLogger.error('Tiêu đề không được để trống ');
                return;
              }

              Navigator.pop(context);

              final success = await controller.postMethod(
                title: titleController.text.trim(),
                body: bodyController.text.trim(),
                userId: 1,
              );
              if (success) onSuccess();
            },
          child: const Text('Tạo', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

}
