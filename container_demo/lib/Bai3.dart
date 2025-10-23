import 'package:flutter/material.dart';

import 'main.dart';

class bai3 extends StatelessWidget{
  const bai3 ({super.key});

  @override
  Widget build (BuildContext context){
    return SizedBox(
      height: 300,
      child: ListView.separated(
        itemCount: 4,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          if(index == 0){
            return Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              ),

              child: Container(
                width: 200,

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 3,
                    color: Colors.red
                  ),
                  color:Colors.white
                ),
                child: Padding(padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Flat Card', style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),),
                      Text('With Border', style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
            );
          }else if(index == 1){
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 10,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border:Border.all(
                    color: Colors.blue,
                    width: 3,
                    ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue, // màu của bóng
                      spreadRadius: 2, // độ lan của bóng
                      blurRadius: 9, // độ mờ của bóng
                      offset: Offset(3, 4), // vị trí lệch: x, y
                    ),
                  ],
                ),
                child: Padding(padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text('Levitate', style: TextStyle(color: Colors.blue, fontSize: 32, fontWeight: FontWeight.bold),),
                            Text('Card', style: TextStyle(color: Colors.blue, fontSize: 32, fontWeight: FontWeight.bold),),
                            Text('With', style: TextStyle(color: Colors.blue, fontSize: 32, fontWeight: FontWeight.bold),),
                            Text('Shadow', style: TextStyle(color: Colors.blue, fontSize: 32, fontWeight: FontWeight.bold),),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            );
          }else if(index == 2){
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purple, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.invert_colors_on_rounded,
                          color: Colors.yellowAccent,
                          size: 70,
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Text('With', style: TextStyle(color: Colors.yellowAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                    Text('Icon', style: TextStyle(color: Colors.yellowAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            );
          }else if(index ==3){
            return nextButton();
          }
        },
      ),
    );
  }
}