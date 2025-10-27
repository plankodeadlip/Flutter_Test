import 'package:flutter/material.dart';

class bai3CustomImage extends StatelessWidget {
  const bai3CustomImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.blue, size: 30),
        ),
        title: Text(
          'CUSTOM IMAGE',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            'assets/images/avatar.png',
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 12,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                boxFitSeperator(BoxFit.cover),
                SizedBox(height: 20),
                boxFitSeperator(
                  BoxFit.cover,
                  boxShadowtype: BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: const Offset(4, 4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget boxFitSeperator(BoxFit fitType, {BoxShadow? boxShadowtype}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(23),
          boxShadow: boxShadowtype != null ? [boxShadowtype] : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            'https://i.pinimg.com/736x/6c/45/f0/6c45f0312092491acb1b9e63f91343dd.jpg',
            fit: fitType,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.error_outline, color: Colors.red, size: 48),
              );
            },
          ),
        ),
      ),
    );
  }
}
