import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareZoomLink extends StatefulWidget {
  @override
  _ShareZoomLinkState createState() => _ShareZoomLinkState();
}

class _ShareZoomLinkState extends State<ShareZoomLink> {
  //this is the meetingTitleController and the ZoomLinkController
  TextEditingController meetingTitleController = TextEditingController();
  TextEditingController zoomLinkController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Zoom Link'),
        backgroundColor:Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: meetingTitleController,
              decoration: InputDecoration(labelText: 'Meeting Title'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: zoomLinkController,
              decoration: InputDecoration(labelText: 'Zoom Link'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // get the title and the meeting link
                String title = meetingTitleController.text;
                String link = zoomLinkController.text;
                //if the title is empty or the link is empty
                if (title.isEmpty  || link.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please don\'t leave any empty fields')),
                  );
                } else {
                  sendWhatsAppMessage(title, link);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Change the background color to green
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust the padding
                textStyle: TextStyle(fontSize: 12), // Adjust the text size
              ),
              child: Text('Share Via WhatsApp', style: TextStyle(fontSize: 12)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Change the background color to green
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust the padding
                textStyle: TextStyle(fontSize: 12), // Adjust the text size
              ),
              child: Text('Back', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  void sendWhatsAppMessage(String meetingTitle, String zoomLink) async {
    String message = "I’d like to invite you to a Zoom meeting titled \"$meetingTitle\"\n"
        "Meeting Link: $zoomLink";
    String deepLink = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    if (await canLaunch(deepLink)) {
      await launch(deepLink);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('WhatsApp is not installed on your device.')),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: ShareZoomLink(),
  ));
}
