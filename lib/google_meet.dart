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

class GoogleMeetIntegrationScreen extends StatefulWidget {
  @override
  _GoogleMeetIntegrationScreenState createState() => _GoogleMeetIntegrationScreenState();
}

class _GoogleMeetIntegrationScreenState extends State<GoogleMeetIntegrationScreen> {
  final TextEditingController _meetingIdController = TextEditingController();
  String _baseMeetUrl = 'https://meet.google.com/'; // Base URL for Google Meet

  Future<void> _launchMeet() async {
    String meetingId = _meetingIdController.text.trim();
    if (meetingId.isNotEmpty) {
      String meetUrl = _baseMeetUrl + meetingId;
      if (await canLaunch(meetUrl)) {
        await launch(meetUrl);
      } else {
        throw 'Could not launch $meetUrl';
      }
    } else {
      // Handle the case where the meeting ID is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a meeting ID.')),
      );
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
            SizedBox(height: 20), // Space between image and input field
            Text(
              'Enter Google Meet Meeting ID',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20), // Space between text and input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _meetingIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Meeting ID',
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(height: 20), // Space between input field and button
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
