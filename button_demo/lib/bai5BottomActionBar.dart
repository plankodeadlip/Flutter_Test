import 'package:flutter/material.dart';

class bai5BottomActionBar extends StatelessWidget{
  const bai5BottomActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        title: const Text(
          'BOTTOM ACTION BAR',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SafeArea(child: Container(
          child: Text('BACKGROUND',style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue)),

        )),
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          color: Colors.blueGrey
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white
            ),
            child: TextButton.icon(
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('CANCELED',
                    style: TextStyle(color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                  duration: Duration(seconds: 1), // thời gian hiển thị
                  behavior: SnackBarBehavior.floating, // hiển thị nổi
                  backgroundColor: Colors.white,
                ),
              );
            },
            icon: Icon(Icons.cancel_rounded,color: Colors.blue,size: 30,),
            label: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
            ),
            child: OutlinedButton.icon(
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('DRAFT SAVED',
                    style: TextStyle(color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                  duration: Duration(seconds: 1), // thời gian hiển thị
                  behavior: SnackBarBehavior.floating, // hiển thị nổi
                  backgroundColor: Colors.white,
                ),
              );
            },
            icon: Icon(Icons.save,color: Colors.blue,size: 30,),
            label: Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),),
          Container(child: ElevatedButton.icon(
            onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('PUBLISH',
                    style: TextStyle(color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),),
                  duration: Duration(seconds: 1), // thời gian hiển thị
                  behavior: SnackBarBehavior.floating, // hiển thị nổi
                  backgroundColor: Colors.white,
                ),
              );
            },
            icon: Icon(Icons.publish,color: Colors.blue,size: 30,),
            label: Text('Publish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),)
        ],
      ),)
        ),
    );
  }
}