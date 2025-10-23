import 'package:flutter/material.dart';
import 'package:container_and_boxdecoration/main.dart';
class bai1 extends StatelessWidget{
  const bai1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,

      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(25, 15, 20, 15),
        separatorBuilder: (context, index) => SizedBox(width: 5,),
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder:(context, index) {
          if (index == 0) {
            return Container(
              width: 120,

              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Single',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent),),
                    Text('Background',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                    Text('Color',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                  ],
                ),
              ),
            );
          }else if (index == 1 ){
            return Container(
              width: 120,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.redAccent, Colors.red],
                    begin: Alignment.topRight,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(
                      color: Colors.black,
                      width: 3
                  )
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('With',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent),),
                    Text('Border',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                  ],
                ),
              ),
            );
          }else if(index == 2){
            return Container(
              width: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orangeAccent, Colors.deepOrange, Colors.red],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                    color: Colors.black,
                    width: 3
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('With',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent),),
                    Text('Radius',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                  ],
                ),
              ),
            );
          }else if(index == 3){
            return Container(
              width: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.orange, Colors.red],
                  begin: Alignment.topRight,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(
                    color: Colors.black,
                    width: 3
                ),
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4), // màu của bóng
                    spreadRadius: 2, // độ lan của bóng
                    blurRadius: 6, // độ mờ của bóng
                    offset: Offset(3, 4), // vị trí lệch: x, y
                  )
                ]
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('With',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent),),
                    Text('Shadow',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                  ],
                ),
              ),
            );
          }else if( index == 4){
            return Container(
              width: 120,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue, Colors.orange, Colors.red],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(
                      color: Colors.black,
                      width: 3
                  ),
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4), // màu của bóng
                      spreadRadius: 2, // độ lan của bóng
                      blurRadius: 6, // độ mờ của bóng
                      offset: Offset(3, 4), // vị trí lệch: x, y
                    )
                  ]
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Already',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent),),
                    Text('Padding',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                  ],
                ),
              ),
            );
          }else if(index ==5){
            return nextButton();
          }
        },
      ),
    );
  }
}