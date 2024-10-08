import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart'; // Import your login screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
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
