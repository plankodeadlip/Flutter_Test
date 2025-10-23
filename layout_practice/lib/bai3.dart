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
        middle: const Text('ROW AND COLUMN COMBINE', style: TextStyle(fontSize: 23, color: CupertinoColors.activeBlue)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(5,0,5,0),
        child: SafeArea(
          child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        Expanded(
                            child: Container(
                              height: 200,
                              width: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 4,
                                      color: CupertinoColors.activeBlue
                                  )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Container', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('Row', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  ],
                                ),
                              ),
                            )
                        ),
                        SizedBox(width: 5),
                        Expanded(
                            child: Container(
                              height: 200,
                              width: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                border: Border.all(
                                  width: 4,
                                  color: CupertinoColors.activeBlue
                                )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Container', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('Row', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  ],
                                ),
                              ),
                            )
                        ),
                        SizedBox(width: 5),
                        Expanded(
                            child: Container(
                              height: 200,
                              width: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 4,
                                      color: CupertinoColors.activeBlue
                                  )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Container', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('Row', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                    Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  ],
                                ),
                              ),
                            )
                        ),
                        SizedBox(width: 5)
                      ],
                    )
                ),
                Expanded(
                    child: Container(

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(
                              width: 4,
                              color: CupertinoColors.activeBlue
                          )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Container', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                            Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                            Text('Row', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                            Text('2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                          ],
                        ),
                      ),
                    )
                ),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            width: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                border: Border.all(
                                    width: 4,
                                    color: CupertinoColors.activeBlue
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Container', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  Text('1', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  Text('Row', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  Text('3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            height: 200,
                            width: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                border: Border.all(
                                    width: 4,
                                    color: CupertinoColors.activeBlue
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Container', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  Text('2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  Text('Row', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                  Text('3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: CupertinoColors.activeBlue)),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                )
              ],
            ),
          )
        ),
      )
    );
  }
}