import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bai2 extends StatelessWidget {
  const bai2({super.key});

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
        middle: const Text('BASIC COLUMN', style: TextStyle(fontSize: 25)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          border: Border.all(
                              width: 3,
                              color: Colors.yellowAccent
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          differentContainer('Cross'),
                          differentContainer('Axis'),
                          differentContainer('Alignment'),
                          differentContainer('Start'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          border: Border.all(
                              width: 3,
                              color: Colors.yellowAccent
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          differentContainer('Cross'),
                          differentContainer('Axis'),
                          differentContainer('Alignment'),
                          differentContainer('Center'),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
              Expanded(child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          border: Border.all(
                              width: 3,
                              color: Colors.yellowAccent
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          differentContainer('Cross'),
                          differentContainer('Axis'),
                          differentContainer('Alignment'),
                          differentContainer('End'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          border: Border.all(
                              width: 3,
                              color: Colors.yellowAccent
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          differentContainer('Cross'),
                          differentContainer('Axis'),
                          differentContainer('Alignment'),
                          differentContainer('Stretch'),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
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
            ? Colors
                  .indigo // 👈 fallback: nếu không có gradient thì dùng màu này
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
