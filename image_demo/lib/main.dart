import 'package:flutter/material.dart';

import 'bai1AssetsImage.dart';
import 'bai2InternetImage.dart';
import 'bai3CustomImage.dart';
import 'bai3CustomImageBoxFit.dart';
import 'bai4GalleryLayout.dart';
import 'bai5ImageCarousel.dart';
import 'bai5InstagramFeed.dart';
import 'bai5ProductCard.dart';
import 'bai5ProfileScreen.dart';
import 'dddd.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Button Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BUTTON DEMO',
          style: TextStyle(
            fontSize: 24,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                mainButton(
                  text: 'Bai 1: Asset Image',
                  destination: bai1AssetsImage(),
                ),
                SizedBox(height: 10),
                mainButton(
                  text: 'Bai 2: Internet Image',
                  destination: bai2InternetImage(),
                ),
                SizedBox(height: 10),
                mainButton(
                  text: 'Bai 3: Custom Image Box Fit',
                  destination: bai3CustomImageBoxFit(),
                ),
                SizedBox(height: 10),
                mainButton(
                  text: 'Bai 3: Custom Image',
                  destination: bai3CustomImage(),
                ),
                SizedBox(height: 10),
                mainButton(
                  text: 'Bai 4: Gallery Layout',
                  destination: bai4GalleryLayout(),
                ),
                SizedBox(height: 10),
                mainButton(
                  text: 'Bai 5: Profile Screen',
                  destination: bai5ProfileScreen(),
                ),
                SizedBox(height: 10),
                mainButton(
                  text: 'Bai 5: Product Card',
                  destination: bai5Productcard(),
                ),
                SizedBox(height: 10),
                mainButton(
                  text: 'Bai 5: Image Carousel',
                  destination: bai5ImageCarousel(),
                ),
                SizedBox(height: 10),
                mainButton(
                  text: 'Bai 5: Instagram Feed',
                  destination: bai5InstagramFeed(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class mainButton extends StatelessWidget {
  const mainButton({super.key, required this.text, required this.destination});
  final String text;
  final Widget destination;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 4, color: Colors.blue),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
