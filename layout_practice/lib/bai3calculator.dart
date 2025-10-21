import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class bai3Calculator extends StatelessWidget {
  const bai3Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalculatorScreen();
  }
}


class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String output = '0';
  double num1 = 0;
  double num2 = 0;
  String operator = '';
  String history = '';
  bool justCalculated = false; // ✅ Để reset sau khi bấm "="

  void buttonClick(String value) {
    setState(() {
      // ✅ Reset hoàn toàn
      if (value == 'C') {
        input = '';
        output = '0';
        num1 = 0;
        num2 = 0;
        operator = '';
        history = '';
        justCalculated = false;
        return;
      }

      // ✅ Nếu vừa bấm "=" mà lại bấm số -> reset input
      if (justCalculated &&
          !['+', '-', '*', '/', '×', '÷', '='].contains(value)) {
        input = '';
        justCalculated = false;
      }

      // ✅ Xóa ký tự
      if (value == '<=') {
        if (input.isNotEmpty) input = input.substring(0, input.length - 1);
        return;
      }

      // ✅ Phép toán: xử lý nối tiếp
      if (['+', '-', '*', '/', '×', '÷'].contains(value)) {
        if (input.isNotEmpty) {
          double current = double.tryParse(input) ?? 0;

          if (operator.isNotEmpty) {
            // Nếu đã có phép toán trước đó → tính kết quả tạm
            num2 = current;
            num1 = _calculate(num1, num2, operator);
          } else {
            num1 = current;
          }

          operator = (value == '×')
              ? '*'
              : (value == '÷')
              ? '/'
              : value;
          history =
              '${num1.toStringAsFixed(num1.truncateToDouble() == num1 ? 0 : 2)} ${_displayOperator(operator)}';
          input = '';
          justCalculated = false;
        } else if (output.isNotEmpty && !['Error', '∞'].contains(output)) {
          // Trường hợp người dùng bấm phép toán ngay sau "="
          num1 = double.tryParse(output) ?? 0;
          operator = (value == '×')
              ? '*'
              : (value == '÷')
              ? '/'
              : value;
          history = '$output ${_displayOperator(operator)}';
          input = '';
          justCalculated = false;
        }
        return;
      }

      // ✅ Tính kết quả
      if (value == '=') {
        num2 = double.tryParse(input) ?? 0;
        double result = _calculate(num1, num2, operator);
        output = (result == double.infinity)
            ? 'Error'
            : result.toStringAsFixed(
                result.truncateToDouble() == result ? 0 : 2,
              );

        history = '$num1 ${_displayOperator(operator)} $num2';
        input = output;
        operator = '';
        num1 = result;
        justCalculated = true;
        return;
      }

      // ✅ Phần trăm
      if (value == '%') {
        double number = double.tryParse(input) ?? 0;
        input = (number / 100).toString();
        return;
      }

      // ✅ Đổi dấu
      if (value == '±') {
        if (input.isNotEmpty && input != '0') {
          input = input.startsWith('-') ? input.substring(1) : '-$input';
        }
        return;
      }

      // ✅ Nhập số và dấu '.'
      if (value == '.' && input.contains('.')) return;
      input += value;
    });
  }
  // Hàm tính toán chung
  double _calculate(double n1, double n2, String op) {
    switch (op) {
      case '+':
        return n1 + n2;
      case '-':
        return n1 - n2;
      case '*':
        return n1 * n2;
      case '/':
        return n2 != 0 ? n1 / n2 : double.infinity;
      default:
        return n2;
    }
  }

  // Chuyển ký hiệu hiển thị
  String _displayOperator(String op) {
    switch (op) {
      case '*':
        return '×';
      case '/':
        return '÷';
      default:
        return op;
    }
  }

  // Hàm tạo nút
  Widget calButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: () => buttonClick(text),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory, // 🔹 Tắt hiệu ứng vàng
            overlayColor: WidgetStateProperty.all(
              Colors.transparent,
            ), // 🔹 Không đổi màu khi nhấn
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 22),
            ),
            backgroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: CupertinoColors.activeBlue,
                  width: 6,
                ),
              ),
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) => states.contains(WidgetState.pressed)
                  ? Colors.orange
                  : CupertinoColors.activeBlue,
            ),
            side: WidgetStateProperty.resolveWith<BorderSide>(
              (states) => states.contains(WidgetState.pressed)
                  ? const BorderSide(color: Colors.orange, width: 2)
                  : const BorderSide(
                      color: CupertinoColors.activeBlue,
                      width: 2,
                    ),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        leading: IconTheme(
          data: const IconThemeData(size: 28, color: CupertinoColors.activeBlue),
          child: CupertinoNavigationBarBackButton(
            color: CupertinoColors.activeBlue,
            onPressed: () => Navigator.pop(context),
          ),
        ),

        middle: const Text(
          'Calculator',
          style: TextStyle(fontSize: 38, color: CupertinoColors.activeBlue),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // ✅ Phần hiển thị gồm 2 dòng
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    history,
                    style: const TextStyle(color: Colors.grey, fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    input.isEmpty ? output : input,
                    style: const TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontSize: 56,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ✅ Các hàng nút
            Column(
              children: [
                Row(
                  children: [
                    calButton('C'),
                    calButton('<='),
                    calButton('%'),
                    calButton('/'),
                  ],
                ),
                Row(
                  children: [
                    calButton('7'),
                    calButton('8'),
                    calButton('9'),
                    calButton('×'),
                  ],
                ),
                Row(
                  children: [
                    calButton('4'),
                    calButton('5'),
                    calButton('6'),
                    calButton('-'),
                  ],
                ),
                Row(
                  children: [
                    calButton('1'),
                    calButton('2'),
                    calButton('3'),
                    calButton('+'),
                  ],
                ),
                Row(
                  children: [
                    calButton('±'),
                    calButton('0'),
                    calButton('.'),
                    calButton('='),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset toàn bộ biến khi widget bị hủy (thoát màn hình)
    input = '';
    output = '0';
    num1 = 0;
    num2 = 0;
    operator = '';
    history = '';
    justCalculated = false;

    super.dispose(); // gọi hàm gốc để đảm bảo Flutter giải phóng tài nguyên
  }
}
