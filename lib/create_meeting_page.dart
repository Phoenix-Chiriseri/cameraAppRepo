import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreateMeetingPage extends StatelessWidget {
  const CreateMeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Google Meet Meeting'),
      ),
      body: const WebView(
        initialUrl: 'https://meet.google.com/new', // URL to create a new meeting
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
