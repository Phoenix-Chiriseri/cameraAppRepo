import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This will navigate to the '/home' route after 10 seconds.
    Future.delayed(Duration(seconds: 10), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('MedStake'),
        backgroundColor: Colors.blue, // Set the AppBar color to blue
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0), // Adjust the top padding as needed
          child: Image.asset('assets/stake.png'), // Make sure to place the image in the 'assets' directory
        ),
      ),
    );
  }
}
