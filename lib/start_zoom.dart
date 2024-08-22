import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(ZoomIntegrationApp());
}

class ZoomIntegrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ZoomIntegrationPage(),
    );
  }
}

class ZoomIntegrationPage extends StatefulWidget {
  @override
  _ZoomIntegrationPageState createState() => _ZoomIntegrationPageState();
}

class _ZoomIntegrationPageState extends State<ZoomIntegrationPage> {
  final String jwtToken='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJuRVVURE1iSFFYT2JoRFRrQzBiTGRRIiwiZXhwIjoxNzI0Mjg0MjgzLCJpYXQiOjE3MjQyODA2ODN9.lrpwGXDW2g1W9r3Jg39SvqcGJ2ZKtF5g8d6IQEkt24A'; // Replace with your JWT token
  String _errorMessage='';
  bool _isCreatingMeeting=false;

  Future<void> _createMeeting() async {
    if (_isCreatingMeeting) return; // Prevent multiple concurrent requests

    setState(() {
      _isCreatingMeeting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.zoom.us/v2/users/me/meetings'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'topic': 'Zoom Meeting',
          'type': 2, // Scheduled meeting
          'start_time': DateTime.now().add(Duration(hours: 1)).toUtc().toIso8601String(),
          'duration': 60,
          'timezone': 'UTC',
        }),
      );

      // Check and log the response
      if (response.statusCode == 200) {
        final meetingData = json.decode(response.body);
        final joinUrl = meetingData['join_url'];

        if (joinUrl != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Meeting created: $joinUrl')),
          );
        } else {
          setState(() {
            _errorMessage = 'Failed to retrieve meeting URL from response.';
          });
        }
      } else {
        // Log detailed response body and status code
        setState(() {
          _errorMessage = 'Failed to create meeting. Status code: ${response.statusCode}, Response: ${response.body}';
        });
      }
    } catch (e) {
      // Log the actual exception
      setState(() {
        _errorMessage = 'Error creating meeting: $e';
      });
    } finally {
      setState(() {
        _isCreatingMeeting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zoom Integration')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isCreatingMeeting ? null : _createMeeting,
              child: Text('Create Zoom Meeting'),
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
