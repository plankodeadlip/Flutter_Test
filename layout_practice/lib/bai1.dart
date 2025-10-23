import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bai1 extends StatelessWidget {
  const bai1({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.back,
            color: CupertinoColors.activeBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        middle: const Text('BASIC ROW', style: TextStyle(fontSize: 25)),
      ),

      child: Padding(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        differentContainer('Main', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                        SizedBox(width: 2,),
                        differentContainer('Axis', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                        SizedBox(width: 2,),
                        differentContainer('Alignment', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                        SizedBox(width: 2,),
                        differentContainer('Start', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      differentContainer('Main', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Axis', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Alignment', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Center', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      differentContainer('Main', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Axis', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Alignment', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('End', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      differentContainer('Main', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Axis', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Alignment', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Space', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Between', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      differentContainer('Main', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Axis', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Alignment', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Space', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Around', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      differentContainer('Main', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Axis', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Alignment', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Space', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                      SizedBox(width: 2,),
                      differentContainer('Evenly', gradient:LinearGradient(colors:[Colors.deepPurple,Colors.indigo],begin: AlignmentGeometry.topRight, end: AlignmentGeometry.bottomLeft)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget differentContainer(String text, {Gradient? gradient}) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: gradient, // 👈 Dùng gradient nếu có
        color: gradient == null
            ? Colors.indigo // 👈 fallback: nếu không có gradient thì dùng màu này
            : null,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 3, color: Colors.indigoAccent),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
