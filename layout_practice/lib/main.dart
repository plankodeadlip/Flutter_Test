import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:layout_practice/bai3.dart';
import 'bai1.dart';
import 'bai2.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('LAYOUT PRACTISE', style: TextStyle(fontSize: 25)),
      ),
      child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const Bai1()),
                    );
                  },
                  child: const Text('Bài 1: Basic Row'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const Bai2()),
                    );
                  },
                  child: const Text('Bài 2: Basic Column'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const bai3()),
                    );
                  },
                  child: const Text('Bài 3: Row And Column Combine'),
                )
              ]
          ),
      )
    );
  }
}
