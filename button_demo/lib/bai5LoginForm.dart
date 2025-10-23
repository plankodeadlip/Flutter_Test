import 'package:flutter/material.dart';

class bai5LoginForm extends StatefulWidget {
  const bai5LoginForm({super.key});

  @override
  State<bai5LoginForm> createState() => _bai5LoginFormState();
}

class _bai5LoginFormState extends State<bai5LoginForm> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        title: const Text(
          'LOGIN FORM NO DATA REUSE',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Icon(Icons.adb, size: 150, color: Colors.blue),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Nhập email của bạn',
                              contentPadding: const EdgeInsets.all(16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 4,
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 4,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            icon: Icon(
                              Icons.fingerprint_sharp,
                              size: 40,
                              color: Colors.blue,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Nhập mật khẩu',
                              contentPadding: const EdgeInsets.all(16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 4,
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 4,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            icon: Icon(
                              Icons.remove_red_eye_sharp,
                              size: 40,
                              color: Colors.blue,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Login Button
                Container(
                  child: SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // màu nền nút
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // bo góc
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // màu chữ
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Checkbox + Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.scale(
                          scale: 1.5, // tăng kích thước lên 1.5 lần
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (v) {
                                  setState(() {
                                    rememberMe = v ?? false;
                                  });
                                },
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Signup row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account?",
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 18, 0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
