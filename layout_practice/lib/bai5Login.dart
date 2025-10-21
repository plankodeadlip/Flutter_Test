import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bai5Login extends StatefulWidget {
  const bai5Login({super.key});

  @override
  State<bai5Login> createState() => _bai5LoginState();
}

class _bai5LoginState extends State<bai5Login> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'LOGIN FORM NO DATA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Icon(
                      CupertinoIcons.ant_fill,
                      size: 100,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoTextField(
                            placeholder: 'Email',
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: CupertinoColors.activeBlue,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: CupertinoColors.activeBlue,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Icon(Icons.fingerprint_sharp, size: 40),
                              onPressed: (){}
                          )
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoTextField(
                            placeholder: 'Password',
                            padding: EdgeInsets.all(16),
                            obscureText: true,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: CupertinoColors.activeBlue,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: CupertinoColors.activeBlue,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Icon(Icons.face_outlined, size: 40),
                              onPressed: (){}
                          )
                        ),
                      ],
                    ),
                  ],
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
                          scale: 2, // tăng kích thước lên 1.5 lần
                          child: CupertinoCheckbox(
                            value: rememberMe,
                            onChanged: (v) {
                              setState(() {
                                rememberMe = v ?? false;
                              });
                            },
                          ),
                        ),
                        Text('Remember me', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    Container(
                      child: CupertinoButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Login Button
                Container(
                  child: SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () {},
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Signup row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account?", style: TextStyle(fontSize: 20)),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CupertinoButton(
                        onPressed: () {},
                        child: Text('Sign up', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
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
