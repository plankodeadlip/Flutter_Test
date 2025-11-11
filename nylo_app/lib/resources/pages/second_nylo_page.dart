import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../app/controllers/home_controller_controller.dart';
import '../../app/events/eventHandler.dart';

class ProfilePage extends NyStatefulWidget<HomeControllerController> {
  ProfilePage({super.key});

  @override
  createState() => _ProfilePageState();
}

class _ProfilePageState extends NyPage<ProfilePage> {
  String? name;

  @override
  get init => () {
        final pageData = widget.data();
        name = pageData?['name'];
        print("Dữ liệu nhận được: $pageData");
        setState(() {});
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Second Nylo',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.controller.counterShow,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
              Text('Đây là page thứ 2',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
              Text('Data truyền đến là : $name',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
              ElevatedButton(
                  onPressed: () {
                    event<ButtonPressedEvent>();
                    widget.controller.counterReset();
                    setState(() {
                    });
                    pop();
                  },
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 3, color: Colors.blue),
                        color: Colors.white),
                    height: 100,
                    width: 200,
                    alignment: Alignment.center,
                    child: Text('Quay lại',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  )),
              ElevatedButton(
                  onPressed: () {
                    event<ButtonPressedEvent>();
                    widget.controller.counterIncrease();
                      updateState((){
                      });
                      routeTo("/third",
                      data: {"status": "Route từ page thứ hai"});},
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 100,
                    width: 200,
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Text(
                      'Route đến page thứ ba',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
