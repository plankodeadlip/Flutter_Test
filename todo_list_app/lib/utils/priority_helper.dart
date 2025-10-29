import 'package:flutter/material.dart';
import '../models/todo.dart';

class PriorityHelper {
  static Color getColor(Priority priority) {
    switch (priority) {
      case Priority.High:
        return Colors.red;
      case Priority.Medium:
        return Colors.yellow;
      case Priority.Low:
        return Colors.greenAccent;
    }
  }
}