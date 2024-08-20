import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

void main() {
  runApp(GoogleMeetsApp());
}

//this is the google meets widget that will run when the applicaiton loads
class GoogleMeetsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MeetsState(),
    );
  }
}

class MeetsState extends StatefulWidget {
  @override
  _MeetsState createState() => _MeetsState();
}

class _MeetsState extends State<MeetsState> {
  final String clientId = '500686653155-i24aakgq6a04ecul97h16qcpg9s64aig.apps.googleusercontent.com';
  final String redirectUri = 'YOUR_REDIRECT_URI';
  final List<String> _scopes = [calendar.CalendarApi.calendarScope];

  final FlutterAppAuth _flutterAppAuth = FlutterAppAuth();

  Future<void> _authenticateWithGoogle() async {
    try {
      final AuthorizationTokenResponse? result = await _flutterAppAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUri,
          scopes: _scopes,
        ),
      );

      if (result != null) {
        final accessToken = result.accessToken;
        if (accessToken != null) {
          await _createEvent(accessToken);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to get access token')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authorization result is null')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _createEvent(String accessToken) async {
    final authClient = await auth.authenticatedClient(
      http.Client(),
      auth.AccessCredentials(
        auth.AccessToken('Bearer', accessToken, DateTime.now().add(Duration(hours: 1))),
        null,
        _scopes,
      ),
    );

    var calendarApi = calendar.CalendarApi(authClient);

    var newEvent = calendar.Event(
      summary: 'New Meeting',
      start: calendar.EventDateTime(
        dateTime: DateTime.now().add(Duration(hours: 1)),
        timeZone: 'America/Los_Angeles',
      ),
      end: calendar.EventDateTime(
        dateTime: DateTime.now().add(Duration(hours: 2)),
        timeZone: 'America/Los_Angeles',
      ),
      description: 'A new meeting created from Flutter app.',
      location: 'Virtual',
    );

    var calendarId = 'primary';
    var createdEvent = await calendarApi.events.insert(newEvent, calendarId);

    print('Event created: ${createdEvent.htmlLink}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event created: ${createdEvent.htmlLink}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Calendar Integration')),
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticateWithGoogle,
          child: Text('Authenticate with Google'),
        ),
      ),
    );
  }
}
