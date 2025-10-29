import 'package:flutter/material.dart';
import 'package:todo_list_app/screens/to_do_screen.dart';
import 'models/todo.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const ToDoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}