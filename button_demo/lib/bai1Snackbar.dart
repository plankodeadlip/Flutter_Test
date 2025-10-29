import 'package:flutter/material.dart';

class bai1SnackBar extends StatelessWidget {
  const bai1SnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    String currentButton = '';
    return SafeArea(
        child:Padding(padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child:
              TextButton(
                style: TextButton.styleFrom(

                    padding: EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                    backgroundColor: Colors.yellowAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Text Button',
                  style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              )),

              Expanded(child: Container(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  onPressed: () {
                    currentButton = 'Elevated Button';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Bạn đã nhấn vào ${currentButton}', style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),),
                        duration: Duration(seconds: 1), // thời gian hiển thị
                        behavior: SnackBarBehavior.floating, // hiển thị nổi
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                  child: const Text(
                    'Elevated Button',
                    style: TextStyle(fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                ),
              )),
              Expanded(child: TextButton(
                style: ElevatedButton.styleFrom(

                    padding: EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                    backgroundColor: Colors.yellowAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                onPressed: () {
                  currentButton = 'Text Button';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bạn đã nhấn vào ${currentButton}',
                        style: TextStyle(color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),),
                      duration: Duration(seconds: 1), // thời gian hiển thị
                      behavior: SnackBarBehavior.floating, // hiển thị nổi
                      backgroundColor: Colors.white,
                    ),
                  );
                },
                child: const Text(
                  'Text Button',
                  style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              )),
              Expanded(child: Container(
                padding: EdgeInsets.all(20),
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(10)
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    currentButton = 'Outlined Button';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bạn đã nhấn vào ${currentButton}',
                          style: TextStyle(color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),),
                        duration: Duration(seconds: 1), // thời gian hiển thị
                        behavior: SnackBarBehavior.floating, // hiển thị nổi
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                  child: const Text(
                    'Outlined Button',
                    style: TextStyle(fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                ),
              )),
              Expanded(child: Container(
                padding: EdgeInsets.all(20),
                child: IconButton(
                  icon: Icon(Icons.insert_emoticon, size: 40,),
                  style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onPressed: () {
                    currentButton = 'Icon Button';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bạn đã nhấn vào ${currentButton}',
                          style: TextStyle(color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),),
                        duration: Duration(seconds: 1), // thời gian hiển thị
                        behavior: SnackBarBehavior.floating, // hiển thị nổi
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                ),
              )),
              Expanded(child: Container(
                padding: EdgeInsets.all(20),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    currentButton = 'Floating Action Button';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bạn đã nhấn vào ${currentButton}',
                          style: TextStyle(color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),),
                        duration: Duration(seconds: 1), // thời gian hiển thị
                        behavior: SnackBarBehavior.floating, // hiển thị nổi
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                  label: Text(
                    'Floating Action Button',
                    style: TextStyle(fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                ),
              )),
            ],
          ),)
    );
  }
}