import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const CustomActionButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Đây chính là code của hàm _buildButton cũ của bạn
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 3, color: color),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}