import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/todo.dart';

class listSection extends StatelessWidget {
  final List<Todo> toDo;

  const listSection({super.key, required this.toDo});

  @override
  Widget build(BuildContext context) {
    var total = toDo.length;
    final completed = toDo.where((t) => t.isCompleted).length;
    final notcompleted = total - completed;
    final highPriority = toDo.where((t) => t.priority == Priority.High).length;
    final completionRate = total > 0
        ? (completed / total * 100).toStringAsFixed(0)
        : '0';

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.doc_text_fill,
                      color: Colors.green,
                      size: 20,
                    ),
                    Text(
                      '${total}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(CupertinoIcons.doc_fill, color: Colors.red, size: 20),
                    Text(
                      '${notcompleted}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.doc_checkmark_fill,
                      color: Colors.blue,
                      size: 20,
                    ),
                    Text(
                      '${completed}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.doc_on_clipboard,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      '${highPriority}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              children: [
                SizedBox(
                  child: Text(
                    'Tiến độ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: total > 0 ? (completed / total) : 0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(total > 0 ? (completed / total) : 0),
                      ),
                      minHeight: 10,
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                SizedBox(
                  child: Text(
                    '${completionRate}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getProgressColor(
                        total > 0 ? (completed / total) : 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.blue;
    if (progress >= 0.3) return Colors.orange;
    return Colors.red;
  }
}
