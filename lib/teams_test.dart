import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MaterialApp(
    home: TeamsHandler(),
  ));
}

class TeamsHandler extends StatelessWidget {
  const TeamsHandler({super.key});

  Future<void> _openTeamsApp() async {
    const url = 'msteams://';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      const fallbackUrl = 'https://teams.microsoft.com';
      if (await canLaunch(fallbackUrl)) {
        await launch(fallbackUrl);
      } else {
        print('Could not open Microsoft Teams.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Teams Meeting'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Display the GIF
              Image.asset(
                'assets/microsoftTeams.jpg',
                width: 700, // Adjust the width as needed
                height: 500, // Adjust the height as needed
              ),
              const SizedBox(height: 20), // Space between the GIF and the button
              ElevatedButton(
                onPressed: _openTeamsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Open Microsoft Teams App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
