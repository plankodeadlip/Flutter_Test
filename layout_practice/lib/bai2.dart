import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bai2 extends StatelessWidget {
  const Bai2({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
          onPressed: () => Navigator.pop(context),
        ),
        middle: const Text('BASIC COLUMN', style: TextStyle(fontSize: 25)),
      ),
      child:Padding(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: ListView.separated(
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index)=>SizedBox(height: 10),
            itemCount: 4,
            itemBuilder: (context, index) {
              if (index ==0){
                return Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color.fromARGB(222, 98, 98,1), Color.fromARGB(255, 184, 140,1)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cross', style: TextStyle(color: Colors.yellowAccent, fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('Axis',style: TextStyle(color: Colors.yellowAccent, fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('Alignment',style: TextStyle(color: Colors.yellowAccent, fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('Start',style: TextStyle(color: Colors.yellowAccent, fontWeight:FontWeight.bold, fontSize: 30)),
                      ],
                    ),
                  ),
                );
              }else if(index == 1){
                return Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(218, 226, 248,1), Color.fromARGB(214, 164, 164,1)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Cross', style: TextStyle(color: Color(0xFF4B3832), fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('Axis',style: TextStyle(color: Color(0xFF4B3832), fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('Alignment',style: TextStyle(color: Color(0xFF4B3832), fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('Center',style: TextStyle(color: Color(0xFF4B3832), fontWeight:FontWeight.bold, fontSize: 30)),
                        ],
                    ),
                  )
                );
              }else if(index == 2){
                return Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(72, 0, 72, 1), Color.fromARGB(192, 72, 72, 1)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Cross', style: TextStyle(color: Color(0xFFB3E5FC), fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('Axis',style: TextStyle(color: Color(0xFFB3E5FC), fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('Alignment',style: TextStyle(color: Color(0xFFB3E5FC), fontWeight:FontWeight.bold, fontSize: 30)),
                        Text('End',style: TextStyle(color: Color(0xFFB3E5FC), fontWeight:FontWeight.bold, fontSize: 30)),
                      ],
                    ),
                  )
                );
              }else if(index == 3){
                return Container(
                  width: 250,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color.fromARGB(220, 40, 36, 1), Color.fromARGB(74, 86, 157, 1)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                    child: Padding(padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Cross', style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                          Text('Axis',style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                          Text('Alignment',style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                          Text('Stretch',style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                          Text('Will',style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                          Text('Stretch',style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                          Text('Fitting',style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                          Text('All',style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                          Text('Line',style: TextStyle(color: Color(0xFFFFD700), fontWeight:FontWeight.bold, fontSize: 30)),
                        ],
                      ),
                    )
                );
              }
            }
          )
        ),
      )
    );
  }
}
