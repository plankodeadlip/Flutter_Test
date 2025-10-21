import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class bai4 extends StatelessWidget {
  const bai4({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: IconTheme(
          data: const IconThemeData(
            size: 26,
            color: CupertinoColors.activeBlue,
          ),
          child: CupertinoNavigationBarBackButton(
            color: CupertinoColors.activeBlue,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        middle: Text(
          'EXPANDED AND FLEXIBLE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 3),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFDCFFA), Color(0xffd78fee)],
                          begin: AlignmentGeometry.bottomLeft,
                          end: AlignmentGeometry.topRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                        border: Border.all(width: 4, color: Colors.indigo),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Container',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            '1',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffd78fee), Color(0xff9b5de0)],
                          begin: AlignmentGeometry.bottomLeft,
                          end: AlignmentGeometry.topRight,
                        ),
                        border: Border.all(width: 4, color: Colors.indigo),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Container',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            '2',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff9b5de0), Color(0xff4e56c0)],
                          begin: AlignmentGeometry.bottomLeft,
                          end: AlignmentGeometry.topRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(width: 4, color: Colors.indigo),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Container',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            '3',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFDCFFA), Color(0xffd78fee)],
                          begin: AlignmentGeometry.bottomLeft,
                          end: AlignmentGeometry.topRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                        border: Border.all(width: 4, color: Colors.indigo),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Expand chiem',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'het toan bo',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'Khong gian con lai',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xffd78fee), Color(0xff9b5de0)],
                          begin: AlignmentGeometry.bottomLeft,
                          end: AlignmentGeometry.topRight,
                        ),
                        border: Border.all(width: 4, color: Colors.indigo),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Flexible tight',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'giống với',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'Expanded',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'Nếu thừa',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            'Sẽ không ',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'vượt quá',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'Flex',
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff9b5de0), Color(0xff4e56c0)],
                          begin: AlignmentGeometry.bottomLeft,
                          end: AlignmentGeometry.topRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                        ),
                        border: Border.all(width: 4, color: Colors.indigo),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Flexible',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'loose',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'ép',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'khung',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'vừa',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'với ',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                          Text(
                            'content',
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
