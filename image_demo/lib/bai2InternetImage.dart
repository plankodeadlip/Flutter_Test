import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class bai2InternetImage extends StatelessWidget {
  const bai2InternetImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.blue,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
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
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                internetImageDisplay(
                  'https://i.pinimg.com/736x/63/d4/09/63d4098b2472d816d6de0076f2b9723a.jpg',
                ),
                const SizedBox(height: 10),
                internetImageDisplay(
                  'https://i.pinimg.com/736x/f8/a4/32/f8a432ff295e5b80c815769f787bfd2b.jpg',
                ),
                const SizedBox(height: 10),
                internetImageDisplay(
                  'https://i.pinimg.com/1200x/7a/b8/6b/7ab86b74315af9b72f54530a62ac2162.jpg',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Hàm hiển thị ảnh Internet có hiệu ứng fade-in + cache
  Widget internetImageDisplay(String imagePath) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(23),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: imagePath,
            fit: BoxFit.cover,
            fadeInDuration: const Duration(milliseconds: 500), // Hiệu ứng mờ dần
            placeholder: (context, url) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    'Đang tải ảnh...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            errorWidget: (context, url, error) => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 8),
                Text('Không thể tải ảnh'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
