import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:provider/provider.dart';
import '../../app/providers/auth_provider.dart';
import '../pages/home_page.dart';

class WelcomePage extends NyStatefulWidget {

  static RouteView path = ("/welcome", (_) => WelcomePage());

  WelcomePage({super.key}) : super(child: () => _WelcomePageState());
}

class _WelcomePageState extends NyPage<WelcomePage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Xin chào, ${user?.username ?? 'Guest'}'),
        actions: [
          IconButton(
              onPressed: () => authProvider.logout(),
              icon: Icon(Icons.logout)
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: ${user?.id}'),
            Text('Email: ${user?.email}'),
          ],
        ),
      ),
    );
  }
}
