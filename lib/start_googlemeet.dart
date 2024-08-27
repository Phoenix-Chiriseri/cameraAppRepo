import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this dependency is in your pubspec.yaml

void main() {
  runApp(GoogleMeetIntegrationApp());
}

class GoogleMeetIntegrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleMeetIntegrationPage(),
    );
  }
}

class GoogleMeetIntegrationPage extends StatefulWidget {
  @override
  _GoogleMeetIntegrationPageState createState() => _GoogleMeetIntegrationPageState();
}

class _GoogleMeetIntegrationPageState extends State<GoogleMeetIntegrationPage> {
  final TextEditingController _meetingIdController = TextEditingController();
  String _errorMessage = '';

  Future<void> _startMeeting() async {
    final meetingId = _meetingIdController.text.trim();
    if (meetingId.isEmpty) {
      setState(() {
        _errorMessage = 'Meeting ID cannot be empty.';
      });
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(meetingId)) {
      setState(() {
        _errorMessage = 'Invalid Meeting ID format. Please enter a valid ID.';
      });
      return;
    }

    final meetUrl = 'https://meet.google.com/$meetingId';

    try {
      if (await canLaunch(meetUrl)) {
        await launch(meetUrl);
      } else {
        setState(() {
          _errorMessage = 'Could not launch Google Meet. Please check the meeting ID and try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error launching Google Meet: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Meet Integration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _meetingIdController,
              decoration: InputDecoration(
                labelText: 'Enter Meeting ID',
                border: OutlineInputBorder(),
                hintText: 'e.g., abc-defg-hij',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _startMeeting,
              child: Text('Start Google Meet'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
