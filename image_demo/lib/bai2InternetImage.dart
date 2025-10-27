import 'package:flutter/material.dart';

class bai2InternetImage extends StatelessWidget {
  const bai2InternetImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.blue,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'INTERNET IMAGE',
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
                SizedBox(height: 10),
                internetImageDisplay(
                  'https://i.pinimg.com/736x/63/d4/09/63d4098b2472d816d6de0076f2b9723a.jpg',
                ),
                SizedBox(height: 10),
                internetImageDisplay(
'https://i.pinimg.com/736x/f8/a4/32/f8a432ff295e5b80c815769f787bfd2b.jpg'                ),
                SizedBox(height: 10),
                internetImageDisplay(
'https://i.pinimg.com/1200x/7a/b8/6b/7ab86b74315af9b72f54530a62ac2162.jpg'                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget internetImageDisplay(String imagePath) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(23),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imagePath,
            fit: BoxFit.cover, // Cắt ảnh vừa khung
            width: 300,
            height: 200,
            // Khi ảnh đang tải
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child; // Ảnh đã load xong
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    Text(
                      'Đang tải ảnh...',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  const Text('Không thể tải ảnh'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
