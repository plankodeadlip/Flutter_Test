import 'dart:async';
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool _isButtonEnabled = false;
  int _countdown = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void _handleCancel() {
    _timer?.cancel();
    Navigator.pop(context, false);
  }

  void _handleConfirm() {
    _timer?.cancel();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Xác Nhận Xóa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          Spacer(),
          Icon(
            Icons.dangerous_outlined,
            size: 30,
            color: Colors.red,
          )
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bạn có chắc muốn xóa công việc này không',
            style: TextStyle(fontSize: 26),
          ),
          Text(
            'Việc xóa dữ liệu của To Do List này không thể phục hồi',
            style: TextStyle(color: Colors.red, fontSize: 18),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: _handleCancel,
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _isButtonEnabled ? _handleConfirm : null,
          child: _isButtonEnabled ? Text('Có') : Text('Chờ ${_countdown}s'),
        ),
      ],
    );
  }
}