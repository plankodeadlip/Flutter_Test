import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/authgate_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:provider/provider.dart';
import '/app/providers/auth_provider.dart';

/// Nylo - Framework for Flutter Developers
/// Docs: https://nylo.dev/docs/6.x

/// Main entry point for the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Nylo.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(), // ✅ Constructor tự gọi
        )
      ],
      child: MaterialApp(
        title: 'Nylo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home:  AuthgatePage(),
      ),
    );
  }
}
