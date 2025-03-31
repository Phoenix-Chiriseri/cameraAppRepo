import 'package:flutter/material.dart';
import 'dart:async';
import 'package:simple_project/new_dash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Ensure widget is still active
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Ensure the stack takes up the whole screen
        children: [
          // Use a SizedBox with full width and height to cover the screen
          SizedBox.expand(
            child: Image.asset(
              'assets/stake.png', // Path to your background image
              fit: BoxFit.cover, // Ensure the image covers the entire screen
            ),
          ),
        ],
      ),
    );
  }
}
