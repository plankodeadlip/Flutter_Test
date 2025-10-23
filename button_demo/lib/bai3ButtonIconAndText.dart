import 'package:flutter/material.dart';

class bai3ButtonIconAndText extends StatelessWidget {
  const bai3ButtonIconAndText({super.key});

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
          'BUTTON ICON AND TEXT',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.adb, size: 30, color: Colors.blue),
                    label: Text(
                      'Elevated Button with icon and text',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.adb, size: 30, color: Colors.blue),
                    label: Text(
                      'Text Button with icon and text',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.adb, size: 30, color: Colors.blue),
                    label: Text(
                      'Outlined Button with icon and text',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 3, color: Colors.blue),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(15),
                  child:GestureDetector(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.adb, color: Colors.blue,),
                            SizedBox(width: 10,),
                            Text('This is Gesture Detector', style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),)
                          ],
                        ),
                      ),
                    ),
                    onTap: (){ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Custom Buton but not a button',
                          style: TextStyle(color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),),
                        duration: Duration(seconds: 1), // thời gian hiển thị
                        behavior: SnackBarBehavior.floating, // hiển thị nổi
                        backgroundColor: Colors.white,
                      ),
                    );},
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
