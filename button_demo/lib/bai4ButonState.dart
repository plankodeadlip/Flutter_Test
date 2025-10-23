import 'package:flutter/material.dart';

class bai4ButtonState extends StatelessWidget {
  const bai4ButtonState({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            'BUTTON ICON AND TEXT',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: const ButtonDemo(),
      ),
    );
  }
}

class ButtonDemo extends StatefulWidget {
  const ButtonDemo({super.key});

  @override
  State<ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<ButtonDemo> {
  bool isEnable = true;
  bool isLoading = false;
  bool isToggled = false;
  String selectedOption = 'A';

  void isEnableClick() {
    setState(() {
      isEnable = !isEnable;
    });
  }

  void isLoadingclicked() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Loading xong!')));
  }

  void isToggleClicked() {
    setState(() {
      isToggled = !isToggled;
    });
  }

  void isOptionSelected(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: isEnable ? isEnableClick : null,
                      child: Text(
                        isEnable ? 'CLICK TO DISABLE' : 'DISABLE',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Colors.blue),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: isLoading ? null : isLoadingclicked,
                      child: isLoading
                          ? Container(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                                strokeWidth: 5,
                              ),
                            )
                          : Text(
                              'CLICK TO LOADING',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Colors.blue),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: isToggleClicked,
                      child: Text(isToggled ? 'TOGGLE ON' : 'TOGGLE OFF',style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),),
                      )
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Colors.blue),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double buttonWidth = constraints.maxWidth / 3.05;
                        double butttonHeight = constraints.maxWidth / 3.05;
                        return ToggleButtons(
                          constraints: BoxConstraints.expand(width: buttonWidth, height: butttonHeight),
                          isSelected: [
                            selectedOption == 'A',
                            selectedOption == 'B',
                            selectedOption == 'C',
                          ],
                          onPressed: (index) {
                            setState(() {
                              selectedOption = ['A', 'B', 'C'][index];
                            });
                          },
                          borderRadius: BorderRadius.circular(10),
                          selectedColor: Colors.white,
                          fillColor: Colors.blue,
                          borderColor: Colors.blue,
                          color: Colors.blue,
                          children: const [
                            Text('A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('B', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('C', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
