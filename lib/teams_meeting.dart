import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

void main() {
  //run the application
  runApp(const TeamsApp());
}

class TeamsApp extends StatelessWidget {
  const TeamsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TeamsIntegrationScreen(),
    );
  }
}

class TeamsIntegrationScreen extends StatefulWidget {
  const TeamsIntegrationScreen({super.key});

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
        const SnackBar(content: Text('Please enter a meeting ID.')),
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
        title: const Text('Start Microsoft Teams Meeting'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
            const SizedBox(height: 20),
            Text(
              'Enter Microsoft Teams Meeting ID',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _meetingIdController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Meeting ID',
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Join Teams Meeting'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Microsoft Teams Meeting'),
        backgroundColor: Colors.blue,
      ),
      body: WebViewPlus(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
