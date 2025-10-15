import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFCC80),
          leading: const Icon(Icons.menu),
          title: const Text('My First Flutter App', style: TextStyle(color:Color(0xFFE65100), fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFFE0B2),
                  Color(0xFFFFCC80),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.deepOrange, width: 3)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
              SizedBox(height: 15),
              Text(
                'Xin chào',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Trần Huy Hùng',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ]
          ),
        ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFFB8C00),
          onPressed: () => debugPrint('Floating Action Button clicked'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
