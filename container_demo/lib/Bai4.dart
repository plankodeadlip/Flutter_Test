import 'package:flutter/material.dart';

class informationScreen extends StatelessWidget{
  const informationScreen({super.key});

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
            'PROFILE CARD',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white, // vẫn cần màu trắng để ShaderMask hiển thị đúng
              letterSpacing: 2,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 600,
          width: 350,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF58529), // cam
                  Color(0xFFFEDA77), // vàng
                  Color(0xFFDD2A7B), // hồng
                  Color(0xFF8134AF), // tím
                  Color(0xFF515BD4), // xanh tím
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  width: 3,
                  color: Colors.red
              ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: Colors.red
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox( height: 80,),
              Text('Trần Huy Hùng', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),),
              Text('SWE Học Việc', style: TextStyle(fontSize:25, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Tại VietGIS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 30,),
              Text('tranhung3q88@gmail.com',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor:Colors.white,
                    decorationThickness: 2
                  )
              )
            ],
          ),
        ),
      )
    );
  }
}