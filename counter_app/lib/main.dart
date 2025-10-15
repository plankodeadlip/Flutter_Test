import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CounterScreen());
  }
}

// Khai bao StatefulWidget
class CounterScreen extends StatefulWidget {
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;
  List<String> history = [];
  List<String> afterButton = [];

  // Key để trigger animation
  final GlobalKey<_AnimatedCounterState> _animatedCounterKey =
    GlobalKey<_AnimatedCounterState>();

  final GlobalKey<_AnimatedCounterState> _animatedHistory =
    GlobalKey<_AnimatedCounterState>();

  @override
  void initState() {
    super.initState();
    _loadData(); // Load dữ liệu khi khởi động app
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter') ?? 0;
      history = prefs.getStringList('history') ?? [];
      afterButton = prefs.getStringList('afterButton') ?? [];
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
    await prefs.setStringList('history', history);
    await prefs.setStringList('afterButton', afterButton);
  }

  // Logic khi nhan nut + trigger animation
  void increment() {
    setState(() => counter++);
    adHistory('+1');
    adAfterButton(counter);
    _animatedCounterKey.currentState?.animateUp();
    _saveData();
  }

  void decrement() {
    setState(() => counter--);
    adHistory('-1');
    adAfterButton(counter);
    _animatedCounterKey.currentState?.animateDown();
    _saveData();
  }

  void resetCounter() {
    setState(() => counter = 0);
    adHistory('reset');
    adAfterButton(counter);
    _animatedCounterKey.currentState?.animateUp();
    _saveData();
  }

  void add5() {
    setState(() => counter += 5);
    adHistory('+5');
    adAfterButton(counter);
    _animatedCounterKey.currentState?.animateUp();
    _saveData();
  }

  void minus5() {
    setState(() => counter -= 5);
    adHistory('-5');
    adAfterButton(counter);
    _animatedCounterKey.currentState?.animateDown();
    _saveData();
  }

  void adHistory(String action) {
    setState(() {
      history.insert(0, action);
      if(history.length>= 7){
        history.removeLast();
      }
    });
  }

  void adAfterButton(int action) {
    setState(() {
      afterButton.insert(0, action.toString());
      if(afterButton.length>=7){
        afterButton.removeLast();
      }
    });
  }

  Color getColor() {
    if (counter > 0) return Colors.green;
    if (counter < 0) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter App'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: resetCounter, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: history.isEmpty
                      ? [const Text('👍')]
                      : history.map((item) => Text(item)).toList(),
                ),

                Column(
                  children: afterButton.isEmpty
                      ? [const Text('👍')]
                      : afterButton.map((item) => Text(item)).toList(),
                ),

              ],
            ),
            SizedBox(height: 20),
            const Text('Ban Da Nhan'),
            const SizedBox(height: 20),
            // Sử dụng AnimatedCounter widget
            AnimatedCounter(
              key: _animatedCounterKey,
              counter: counter,
              color: getColor(),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: counter <= 0 ? null : decrement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: counter <= 0 ? Colors.grey : Colors.red,
                  ),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: increment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: counter <= 4 ? null : minus5,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: counter <= 4 ? Colors.grey : Colors.pink,
                  ),
                  child: const Text('-5'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: add5,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('+5'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Class Animation cho Counter
class AnimatedCounter extends StatefulWidget {
  final int counter;
  final Color color;

  const AnimatedCounter({
    Key? key,
    required this.counter,
    required this.color,
  }) : super(key: key);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  // Animation kéo lên (khi tăng)
  void animateUp() {
    setState(() {
      _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    });
    _controller.forward(from: 0);
  }

  // Animation kéo xuống (khi giảm)
  void animateDown() {
    setState(() {
      _slideAnimation = Tween<double>(begin: -30, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Text(
              '${widget.counter}',
              style: TextStyle(
                fontSize: 72,
                color: widget.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}