import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

void main() {
  //run the application
  runApp(TeamsApp());
}

class TeamsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TeamsIntegrationScreen(),
    );
  }
}

class TeamsIntegrationScreen extends StatefulWidget {
  @override
  _TeamsIntegrationScreenState createState() => _TeamsIntegrationScreenState();
}

class _TeamsIntegrationScreenState extends State<TeamsIntegrationScreen> {
  final TextEditingController _meetingIdController = TextEditingController();
  final String _baseTeamsUrl = 'https://teams.microsoft.com/l/meetup-join/';
  String? _meetingUrl;

  void _generateMeetingUrl() {
    final meetingId = _meetingIdController.text;
    if (meetingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a meeting ID.')),
      );
      return;
    }

    setState(() {
      _meetingUrl = '$_baseTeamsUrl$meetingId';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Microsoft Teams Meeting'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/microsoftTeams.jpg', // Your Microsoft Teams image asset
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Enter Microsoft Teams Meeting ID',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _meetingIdController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Meeting ID',
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _generateMeetingUrl();
                if (_meetingUrl != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(url: _meetingUrl!),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Join Teams Meeting'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Microsoft Teams Meeting'),
        backgroundColor: Colors.blue,
      ),
      body: WebViewPlus(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
