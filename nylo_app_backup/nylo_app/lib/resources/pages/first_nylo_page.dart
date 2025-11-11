import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/app/events/eventHandler.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/cupertino.dart';

import '../../app/controllers/home_controller_controller.dart';

class HomePage extends NyStatefulWidget<HomeControllerController> {
  HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends NyPage<HomePage> {
  @override
  get init => () async {
        widget.controller.counterReset();
      };

  @override
  Widget build(BuildContext context) {
    final baseUrl = getEnv('API_BASE_URL');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'First Nylo',
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
              Text('Đây là page đầu tiên',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold)),
              ElevatedButton(
                  onPressed: () {
                    event<ButtonPressedEvent>();
                    widget.controller.counterIncrease();
                    updateState(() {});
                    routeTo("/second", data: {"name": "Trần Huy Hùng"});
                    print(baseUrl);
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
                    child: Text('Route đến page thứ hai',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  )),
              ElevatedButton(
                  onPressed: () {
                    widget.controller.counterIncrease();
                    updateState(() {});
                    routeTo("/third",
                        data: {"status": "Route từ page thứ nhất"});
                  },
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
                  )
              ),
              ElevatedButton(
                  onPressed: () {
                    widget.controller.counterIncrease();
                    updateState(() {});
                    routeTo("/cart_event");
                  },
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
                      'Route đến Cart Page',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
              ),
              ElevatedButton(
                  onPressed: () {
                    widget.controller.counterIncrease();
                    updateState(() {});
                    routeTo("/http_method");
                  },
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
                      'Route đến HTTP Page',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
