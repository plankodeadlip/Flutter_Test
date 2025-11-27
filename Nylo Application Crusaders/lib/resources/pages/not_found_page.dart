import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class NotFoundPage extends StatelessWidget {
  static String path = '/404'; // Standard path for unknown routes
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('404 Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
            SizedBox(height: 16),
            Text(
              'Rất tiếc, không tìm thấy trang này.',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Đường dẫn bạn truy cập không tồn tại.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            TextButton(
              // Route to the initial route (AuthgatePage)
              onPressed: () => routeTo('/', navigationType: NavigationType.pushReplace),
              child: Text('Quay lại trang chủ'),
            ),
          ],
        ),
      ),
    );
  }
}