import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bai3 extends StatelessWidget{
  const bai3({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
          onPressed: () => Navigator.pop(context),
        ),
        middle: const Text('ROW AND COLUMN COMBINE', style: TextStyle(fontSize: 23)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
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
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/avatar.png'),
                          b
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tran Huy Hung', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          Text('1 gio truoc', style: TextStyle(color: Colors.grey),)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green
                  ),
                  child: Text('hello'),
                ),

                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue
                  ),
                  child: Text('hello'),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}