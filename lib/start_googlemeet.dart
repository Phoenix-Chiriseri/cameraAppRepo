import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_project/widgets/inputTextWidget.dart'; // Import your custom widget

void main() {
  runApp(MaterialApp(
    home: GoogleMeetIntegrationPage(),
  ));
}

class GoogleMeetIntegrationPage extends StatefulWidget {
  @override
  _GoogleMeetIntegrationPageState createState() => _GoogleMeetIntegrationPageState();
}

class _GoogleMeetIntegrationPageState extends State<GoogleMeetIntegrationPage> {
  final TextEditingController _meetingIdController = TextEditingController();
  String _errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> _startMeeting() async {
    final meetingId = _meetingIdController.text.trim();
    if (meetingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meeting ID cannot be empty.')),
      );
      return;
    }
    
    final meetUrl = 'https://meet.google.com/$meetingId';

    try {
      if (await canLaunch(meetUrl)) {
        await launch(meetUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch Google Meet.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching Google Meet: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (175 / 360); // Ratio for web test
    final coverHeight = screenWidth * r;

    final buttonWidth = screenWidth * 0.8;
    final buttonHeight = 55.0;

    final widgetList = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Google Meet Integration',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                labelText: "Enter Meeting ID",
                icon: Icons.video_call, // Use an appropriate icon
                obscureText: false,
                keyboardType: TextInputType.text,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _startMeeting,
                  child: Text("Start Google Meet"),
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Back navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0.0,
                    minimumSize: Size(buttonWidth, buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    "Back",
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
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.asset("assets/google_meet.jpg", fit: BoxFit.cover), // Update asset
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFFb3cde0), Color(0xFFf7f7f7)],
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
