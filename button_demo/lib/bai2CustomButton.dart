import 'package:flutter/material.dart';

class bai2CustomButton extends StatelessWidget {
  const bai2CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    String currentButton = '';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        title: const Text(
          'BUTTON CUSTOM',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.blueAccent,
                        Colors.orangeAccent,
                      ],
                      begin: AlignmentGeometry.topRight,
                      end: AlignmentGeometry.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.blueAccent,
                          width: 3,
                        ),
                      ),
                      shadowColor: Colors.black, // 🌟 màu bóng
                      backgroundColor: Colors.transparent, // 💧 nền mờ nhẹ
                      elevation: 25,
                      padding: EdgeInsets.all(30),
                    ),
                    onPressed: () {
                      currentButton = 'Elevated Button';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Bạn đã nhấn vào ${currentButton} đã thiết kế',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          duration: Duration(seconds: 1), // thời gian hiển thị
                          behavior: SnackBarBehavior.floating, // hiển thị nổi
                          backgroundColor: Colors.white,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gradientText('Custom background color'),
                        gradientText('Custom text color'),
                        gradientText('Custom border radius'),
                        gradientText('Custom Padding'),
                        gradientText('Custom Elevation'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.blueAccent, // 🎨 màu viền
                        width: 7, // 📏 độ dày viền
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // 🌟 bo góc
                      ),
                    ),
                    onPressed: () {
                      currentButton = 'Outlined Button';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Bạn đã nhấn vào ${currentButton} đã thiết kế',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          duration: Duration(seconds: 1), // thời gian hiển thị
                          behavior: SnackBarBehavior.floating, // hiển thị nổi
                          backgroundColor: Colors.white,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        gradientText('Custom border color'),
                        gradientText('Custom border width'),
                        gradientText('Custom border radius'),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                            (states) {
                          if (states.contains(WidgetState.hovered)) {
                            return Colors.orangeAccent; // hover
                          }
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.blue; // nhấn
                          }
                          return Colors.transparent; // mặc định
                        },
                      ),

                      // 🎨 Màu chữ đổi khi hover / pressed
                      foregroundColor: WidgetStateProperty.resolveWith<Color>(
                            (states) {
                          if (states.contains(WidgetState.hovered)) {
                            return Colors.white; // hover
                          }
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.orange; // nhấn
                          }
                          return Colors.indigo; // mặc định
                        },
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                      ),
                    ),
                    onPressed: () {
                      currentButton = 'Text Button';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Bạn đã nhấn vào ${currentButton} đã thiết kế',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          duration: Duration(seconds: 1), // thời gian hiển thị
                          behavior: SnackBarBehavior.floating, // hiển thị nổi
                          backgroundColor: Colors.white,
                        ),
                      );
                    },

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Custom hover background color',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('Custom text color',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('Custom press background color',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gradientText(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.deepPurple, Colors.black],
        begin: AlignmentGeometry.topCenter,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white, // phải để màu trắng để hiện gradient
        ),
      ),
    );
  }
}
