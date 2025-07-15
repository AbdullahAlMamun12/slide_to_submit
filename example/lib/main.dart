import 'package:flutter/material.dart';
import 'package:slide_to_submit_button/slide_to_submit_button.dart';

void main() {
  runApp(const MyApp());
}

/// Entry point of the SlideToSubmit button example app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide To Submit Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xffF0F4F3),
      ),
      home: const ExamplePage(),
    );
  }
}

/// Demonstrates different usages of the SlideToSubmit widget.
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slide To Submit Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Default Usage: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            SlideToSubmit(
              sliderWidth: 150,
              onSubmit: () => _showSnackBar(context, 'Default button submitted!'),
              sliderIcon: Icons.send,
              text: "Submit Now",
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),

            const Text(
              'Custom Usage: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            SlideToSubmit.custom(
              onSubmit: () => _showSnackBar(context, 'Custom widget submitted!'),
              height: 80,
              padding: const EdgeInsets.all(12),
              sliderWidth: 110,
              backgroundDecoration: BoxDecoration(
                color: Colors.deepPurple.shade700,
                borderRadius: BorderRadius.circular(15),
              ),
              foregroundDecoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(15),
              ),
              slider: Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.lock_open, color: Colors.white),
                    Text(
                      "Unlock",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              hint: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedSlideArrow(
                    arrowImage: AssetImage("assets/arrow_right.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}