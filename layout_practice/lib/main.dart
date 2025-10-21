import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'bai3.dart';
import 'bai3post.dart';
import 'bai5Login.dart';
import 'bai1.dart';
import 'bai2.dart';
import 'bai3calculator.dart';
import 'bai4.dart';
import 'bai5EComerce.dart';

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
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: CupertinoColors.activeBlue),
                borderRadius: BorderRadius.circular(12)
              ),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const bai1()),
                  );
                },
                child: const Text('Bài 1: Basic Row'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: CupertinoColors.activeBlue),
                borderRadius: BorderRadius.circular(12)
              ),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const bai2()),
                  );
                },
                child: const Text('Bài 2: Basic Column'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: CupertinoColors.activeBlue),
                borderRadius: BorderRadius.circular(12)
              ),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const bai3()),
                  );
                },
                child: const Text('Bài 3: Row And Column Combine'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: CupertinoColors.activeBlue),
                borderRadius: BorderRadius.circular(12)
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const bai3Calculator(),
                    ),
                  );
                },
                child: const Text('Bài 3: Calculator'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: CupertinoColors.activeBlue),
                borderRadius: BorderRadius.circular(12)
              ),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const bai3Post()),
                  );
                },
                child: const Text('Bài 3: Social Media Post'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: CupertinoColors.activeBlue),
                borderRadius: BorderRadius.circular(12)
              ),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const bai4()),
                  );
                },
                child: const Text('Bài 4: Expanded and FLexible'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: CupertinoColors.activeBlue),
                borderRadius: BorderRadius.circular(12)
              ),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const bai5Login()),
                  );
                },
                child: const Text('Bài 5: Login Form (no data)'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: CupertinoColors.activeBlue),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: CupertinoButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const bai5EComerce()),
                  );
                },
                child: const Text('Bài 5: E - Comerce'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
