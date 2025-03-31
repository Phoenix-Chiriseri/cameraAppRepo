import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Added for launching URLs
import 'package:permission_handler/permission_handler.dart'; // Added for permissions
import 'package:simple_project/widgets/inputTextWidget.dart';
import 'package:simple_project/new_dash.dart';
// Import the database helper

void main() {
  runApp(MaterialApp(
    home: const Telemedicine(),
    routes: {
      '/home': (context) => const Home(), // Define your home screen route
    },
  ));
}

class Telemedicine extends StatefulWidget {
  const Telemedicine({super.key});

  @override
  _TelemedicineState createState() => _TelemedicineState();
}

class _TelemedicineState extends State<Telemedicine> {
  TextEditingController meetingTitleController = TextEditingController();
  TextEditingController zoomLinkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Removed unused field '_isVisible'

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    final status = await Permission.contacts.status;
    if (status.isDenied) {
      await Permission.contacts.request();
    }
  }

  //using deeplink to send a whatsapp message to a user
  void sendWhatsAppMessage(String meetingTitle, String zoomLink) async {
    final String message =
        "I’d like to invite you to a Zoom meeting titled \"$meetingTitle\"\n"
        "Meeting Link: $zoomLink";
    final String deepLink =
        'https://wa.me/?text=${Uri.encodeComponent(message)}';
    if (await canLaunch(deepLink)) {
      await launch(deepLink);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('WhatsApp is not installed on your device.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double r = (175 / 360); // Ratio for web test
    final coverHeight = screenWidth * r;

    final buttonWidth =
        screenWidth * 0.8; // Make buttons a bit smaller than screen width
    const buttonHeight = 55.0; // Set a consistent height for buttons

    final widgetList = [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Share Via WhatsApp',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
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
                controller: meetingTitleController,
                labelText: "Meeting Title",
                icon: Icons.meeting_room, // Updated icon
                obscureText: false,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 12.0),
              InputTextWidget(
                controller: zoomLinkController,
                labelText: "Meeting Link",
                icon: Icons.link,
                obscureText: false,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 15.0),
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0), // Reduced vertical margin
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    String title = meetingTitleController.text;
                    String link = zoomLinkController.text;
                    if (title.isEmpty || link.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please don\'t leave any empty fields')),
                      );
                    } else {
                      sendWhatsAppMessage(title, link);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0.0,
                    minimumSize: Size(buttonWidth, buttonHeight),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8)), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    "Send Invitation",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 8.0), // Reduced space between buttons
              Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0), // Reduced vertical margin
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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8)), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
      const SizedBox(height: 15.0),
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
            backgroundColor: const Color(0xFFdccdb4),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.asset("assets/whatsapp.jpg", fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
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
                    decoration: const BoxDecoration(
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
