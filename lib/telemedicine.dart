// telemedicine_screen.dart

import 'package:flutter/material.dart';

class TelemedicineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TeleMedicine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Connect instantly, manage records efficiently, and provide personalized care from anywhere.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            // You can add more widgets here as needed
          ],
        ),
      ),
    );
  }
}
