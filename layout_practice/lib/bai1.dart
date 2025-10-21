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
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
          onPressed: () => Navigator.pop(context),
        ),
        middle: const Text('BASIC ROW', style: TextStyle(fontSize: 25)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder:(context, index) => SizedBox(width: 20),
            itemBuilder: (context, index) {
              if ( index == 0 ){
                return Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.indigo, Colors.blue],begin: AlignmentGeometry.bottomLeft, end: AlignmentGeometry.topRight ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 3,
                      color: Colors.indigoAccent
                    )
                  ),
                  child: Padding(padding: EdgeInsets.all(5),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Main', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                      Text('Axis',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                      Text('Alignment',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                      Text('Start',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                    ],
                  ),
                  ),
                );
              }else if(index == 1){
                return Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.indigo, Colors.blue,Colors.blue,Colors.orange],begin: AlignmentGeometry.bottomLeft, end: AlignmentGeometry.topRight),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 3,
                          color: Colors.indigoAccent
                      )
                  ),
                  child: Padding(padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Main', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Axis',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Alignment',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        Text('Center',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  ),
                );
              }else if(index == 2){
                return Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue,Colors.blue,Colors.blue,Colors.blue,Colors.orange,Colors.orange],begin: AlignmentGeometry.bottomLeft, end: AlignmentGeometry.topRight),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 3,
                          color: Colors.indigoAccent
                      )
                  ),
                  child: Padding(padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Main', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Axis',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Alignment',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        Text('End',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  ),
                );
              }else if(index == 3){
                return Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.lightBlue,Colors.blue,Colors.blue,Colors.blue,Colors.orange,Colors.orange, Colors.deepOrange],begin: AlignmentGeometry.bottomLeft, end: AlignmentGeometry.topRight),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 3,
                          color: Colors.indigoAccent
                      )
                  ),
                  child: Padding(padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Main', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Axis',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Alignment',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        Text('Space',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Between',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  ),
                );
              }else if( index == 4){
                return Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue,Colors.blue,Colors.blue,Colors.blue,Colors.orange,Colors.orange,Colors.orange,Colors.orange,Colors.deepOrange, Colors.deepOrange],begin: AlignmentGeometry.bottomLeft, end: AlignmentGeometry.topRight),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 3,
                          color: Colors.indigoAccent
                      )
                  ),
                  child: Padding(padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Main', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Axis',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Alignment',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        Text('Space',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Around',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  ),
                );
              }else if(index == 5) {
                return Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue,Colors.blue,Colors.orange,Colors.orange,Colors.orange,Colors.deepOrange, Colors.deepOrange, Colors.red],begin: AlignmentGeometry.bottomLeft, end: AlignmentGeometry.topRight),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          width: 3,
                          color: Colors.indigoAccent
                      )
                  ),
                  child: Padding(padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Main', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Axis',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Alignment',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        Text('Space',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Text('Evenly',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                      ],
                    ),
                  ),
                );
              }
            },
          )
        ),
      )
    );
  }
}
