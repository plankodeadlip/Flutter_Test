import 'package:flutter/material.dart';
import 'dart:ui';

import 'main.dart';

class bai2 extends StatelessWidget {
  const bai2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170, // tăng chút để chứa card thứ 5
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              width: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.orangeAccent, Colors.lightBlue],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('With',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold)),
                    Text('Linear',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                    Text('Gradient',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            );
          } else if (index == 1) {
            return Container(
              width: 120,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.orange, Colors.orangeAccent, Colors.lightBlue],
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('With',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold)),
                    Text('Radial',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                    Text('Gradient',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            );
          } else if (index == 2) {
            return Container(
              width: 120,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('With',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    Text('Image',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.bold)),
                    Text('Background',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            );
          } else if (index == 3) {
            return Container(
              width: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.yellow, Colors.orange],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [Colors.orange, Colors.orangeAccent, Colors.lightBlue],
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Border',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold)),
                      Text('Lots of',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      Text('Color',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            );
          } else if (index == 4) {
            // 🧊 Card có ảnh nền mờ và viền gradient
            return Container(
              margin: const EdgeInsets.all(8),
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(27),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/img.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(


                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'With',
                              style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' Lots of',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Design',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }else if(index ==5){
            return nextButton();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
