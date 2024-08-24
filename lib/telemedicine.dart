import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Added for launching URLs
import 'package:permission_handler/permission_handler.dart'; // Added for permissions
import 'package:simple_project/widgets/inputTextWidget.dart';
import 'package:simple_project/signUpScreen.dart';
import 'package:simple_project/new_dash.dart';
import 'package:simple_project/database_helper.dart'; // Import the database helper

void main() {
  runApp(MaterialApp(
    home: Telemedicine(),
  ));
}

class Telemedicine extends StatefulWidget {
  @override
  _TelemedicineState createState() => _TelemedicineState();
}

class _TelemedicineState extends State<Telemedicine> {
  TextEditingController meetingTitleController = TextEditingController();
  TextEditingController zoomLinkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  void sendWhatsAppMessage(String meetingTitle, String zoomLink) async {
    final String message = "I’d like to invite you to a Zoom meeting titled \"$meetingTitle\"\n"
        "Meeting Link: $zoomLink";
    final String deepLink = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    if (await canLaunch(deepLink)) {
      await launch(deepLink);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('WhatsApp is not installed on your device.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (175 / 360); // Ratio for web test
    final coverHeight = screenWidth * r;

    final widgetList = [
      Row(
        children: [
          SizedBox(width: 28),
          Text(
            'Share Via WhatsApp',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xff000000),
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      SizedBox(height: 12.0),
      Form(
        key: _formKey,
        child: Column(
          children: [
            InputTextWidget(
              controller: meetingTitleController,
              labelText: "Meeting Title",
              icon: Icons.title,
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 12.0),
            InputTextWidget(
              controller: zoomLinkController,
              labelText: "Meeting Link",
              icon: Icons.link,
              obscureText: false,
              keyboardType: TextInputType.url,
            ),
            SizedBox(height: 15.0),
            Container(
              height: 55.0,
              child: ElevatedButton(
                onPressed: () async {
                  String title = meetingTitleController.text;
                  String link = zoomLinkController.text;
                  if (title.isEmpty || link.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please don\'t leave any empty fields')),
                    );
                  } else {
                    sendWhatsAppMessage(title, link);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0.0,
                  minimumSize: Size(150, 40),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)), // Rounded corners
                  ),
                ),
                child: Text(
                  "Send Invitation",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 15.0),
      Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 15.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0),
                    blurRadius: 5.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: (screenWidth / 2) - 40,
              height: 55,
              child: Material(
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  onTap: () {
                    print("facebook tapped");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset("assets/fb.png", fit: BoxFit.cover),
                        SizedBox(width: 7.0),
                        Text("Sign in with\nFacebook"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 15.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 0),
                    blurRadius: 5.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: (screenWidth / 2) - 40,
              height: 55,
              child: Material(
                borderRadius: BorderRadius.circular(12.0),
                child: InkWell(
                  onTap: () {
                    print("google tapped");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset("assets/google.png", fit: BoxFit.cover),
                        SizedBox(width: 7.0),
                        Text("Sign in with\nGoogle"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 15.0),
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
              background: Image.asset("assets/whatsapp.jpg", fit: BoxFit.cover),
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
