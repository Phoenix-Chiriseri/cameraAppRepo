import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Added for launching URLs
import 'package:simple_project/widgets/inputTextWidget.dart'; // Assuming you have this widget
import 'package:simple_project/signUpScreen.dart';
import 'package:simple_project/new_dash.dart';
import 'package:simple_project/database_helper.dart'; // Import the database helper

void main() {
  runApp(MaterialApp(
    home: GoogleMeetIntegrationScreen(), // Updated to use the correct screen
    routes: {
      '/home': (context) => Home(), // Define your home screen route
    },
  ));
}

class GoogleMeetIntegrationScreen extends StatefulWidget {
  @override
  _GoogleMeetIntegrationScreenState createState() => _GoogleMeetIntegrationScreenState();
}

class _GoogleMeetIntegrationScreenState extends State<GoogleMeetIntegrationScreen> {
  final TextEditingController _meetingIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Added form key
  String _baseMeetUrl = 'https://meet.google.com/'; // Base URL for Google Meet
  List<Map<String, dynamic>> results = []; // Example results list

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _createMeeting() async {
    const String createMeetingUrl = 'https://meet.google.com/new'; // URL to create a new meeting
    await _launchUrl(createMeetingUrl);
  }

  Future<void> _searchPatient(BuildContext context) async {
    final id = _meetingIdController.text;
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter meeting id')),
      );
      return;
    }
    // Example query results (replace with actual query logic)
    // results = await DatabaseHelper.getPatientById(id);

    if (results.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Patient Found'),
            content: Text('No patient found with the provided ID.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Search Results'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var patient in results)
                    ListTile(
                      title: Text('ID: ${patient['id']}'),
                      subtitle: Text('Name: ${patient['name']}, Date: ${patient['date']}'),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (175 / 360); // Ratio for web test
    final coverHeight = screenWidth * r;

    final buttonWidth = screenWidth * 0.8; // Make buttons a bit smaller than screen width
    final buttonHeight = 55.0; // Set a consistent height for buttons

    final widgetList = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Search Patient',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff000000),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputTextWidget(
                controller: _meetingIdController,
                labelText: "Enter meeting id",
                icon: Icons.person, // Updated icon
                obscureText: false,
                keyboardType: TextInputType.text,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    final meetingId = _meetingIdController.text.trim();
                    final meetUrl = _baseMeetUrl + meetingId;
                    await _launchUrl(meetUrl); // Launch Meet with ID
                  },
                  child: Text("Join Google Meet"),
                ),
              ),
              SizedBox(height: 8.0), // Reduced space between buttons
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical margin
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _createMeeting, // Create a new meeting
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Change color for differentiation
                    elevation: 0.0,
                    minimumSize: Size(buttonWidth, buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)), // Rounded corners
                    ),
                  ),
                  child: Text(
                    "Create Meeting",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: coverHeight - 25,
            backgroundColor: Color(0xFFdccdb4),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.asset("assets/patient.jpg", fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFFdccdb4), Color(0xFFd8c3ab)],
                ),
              ),
              width: screenWidth,
              height: 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return widgetList[index];
              },
              childCount: widgetList.length,
            ),
          ),
        ],
      ),
    );
  }
}
