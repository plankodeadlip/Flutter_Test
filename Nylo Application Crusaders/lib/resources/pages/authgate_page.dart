import 'package:flutter/material.dart';
import 'package:flutter_app/app/providers/auth_provider.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/login_page.dart';
import 'package:provider/provider.dart';

class AuthgatePage extends StatelessWidget {
  const AuthgatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // 🔄 Đang loading - hiển thị splash screen
        if (authProvider.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải...'),
                ],
              ),
            ),
          );
        }

        // ✅ Đã đăng nhập - chuyển đến HomePage
        if (authProvider.isAuthenticated) {
          return HomePage();
        }

        return LoginPage();
      },
    );
  }
}