import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(GoogleMeet());
}

class GoogleMeet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleMeetIntegrationScreen(),
    );
  }
}

class GoogleMeetIntegrationScreen extends StatelessWidget {
  final String meetUrl = 'https://meet.google.com/xks-brsp-pvi'; // Replace with your Google Meet URL

  Future<void> _launchMeet() async {
    if (await canLaunch(meetUrl)) {
      await launch(meetUrl);
    } else {
      throw 'Could not launch $meetUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Google Meet Meeting'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/googleMeet.png', // Your Google Meet image asset
              width: 150, // Adjust the size as needed
              height: 150,
            ),
            SizedBox(height: 20), // Space between image and button
            Text(
              'Join a Google Meet Meeting',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20), // Space between text and button
            ElevatedButton(
              onPressed: _launchMeet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Text style
              ),
              child: Text('Join Google Meet'),
            ),
          ],
        ),
      ),
    );
  }
}
