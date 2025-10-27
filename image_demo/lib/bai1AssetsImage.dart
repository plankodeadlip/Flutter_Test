import 'package:flutter/material.dart';
import 'dart:math' as math; // để dùng math.pi

class bai1AssetsImage extends StatelessWidget {
  const bai1AssetsImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'ASSET IMAGE',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                assetImageDisplay('assets/images/product9.png'),
                SizedBox(height: 15),
                assetImageDisplay('assets/images/product5.png'),
                SizedBox(height: 15),
                assetImageDisplay('assets/images/product6.png'),
                SizedBox(height: 15),
                assetImageDisplay('assets/images/product7.png'),
                SizedBox(height: 15),
                assetImageDisplay('assets/images/product8.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget assetImageDisplay(String imagePath) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(width: 4, color: Colors.blue),
        ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Transform.rotate(
              angle: 90 * math.pi / 180,
              child: FittedBox(
                  fit: BoxFit.cover,
                child: Transform.translate(offset: Offset(-7, 17),child: Image.asset(imagePath),)
              ),
            ),
          ),
        ),

    );
  }
}
