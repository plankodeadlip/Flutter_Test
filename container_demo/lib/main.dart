import 'package:container_and_boxdecoration/Bai1.dart';
import 'package:container_and_boxdecoration/Bai2.dart';
import 'package:container_and_boxdecoration/Bai3.dart';
import 'package:flutter/material.dart';

import 'Bai4.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const containerAndBoxdecorationScreen(),
    );
  }
}

class containerAndBoxdecorationScreen extends StatelessWidget {
  const containerAndBoxdecorationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF455A64),
      appBar: AppBar(
        // 🔹 Làm nền AppBar gradient
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF263238), Color(0xFF455A64)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 6,
        title: ShaderMask(
          // 🔹 Dùng ShaderMask để tạo gradient cho text
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFFD6D6D6), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
          child: const Text(
            'THUNDERCLOUD',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color:
                  Colors.white, // vẫn cần màu trắng để ShaderMask hiển thị đúng
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero, // tránh padding mặc định nếu muốn
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.red, Colors.orange, Colors.yellow],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ).createShader(Rect.fromLTRB(20, 20, 200, 90)),
              child: const Text(
                'Phan thu nhat',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          bai1(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.orange, Colors.blueAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ).createShader(Rect.fromLTRB(20, 20, 10, 90)),
              child: const Text(
                'Phan thu hai',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          bai2(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.red, Colors.orange, Colors.lime],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ).createShader(Rect.fromLTRB(20, 20, 100, 90)),
              child: const Text(
                'Phan thu ba',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          bai3(),
        ],
      ),
    );
  }
}

class nextButton extends StatelessWidget {
  const nextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          (context),
          MaterialPageRoute(builder: (context) => informationScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text('>', style: TextStyle(fontSize: 20, color: Colors.black)),
    );
  }
}
