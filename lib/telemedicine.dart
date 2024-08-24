import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareZoomLink extends StatefulWidget {
  @override
  _ShareZoomLinkState createState() => _ShareZoomLinkState();
}

class _ShareZoomLinkState extends State<ShareZoomLink> {
  TextEditingController meetingTitleController = TextEditingController();
  TextEditingController zoomLinkController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Zoom Link'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextField(
              controller: meetingTitleController,
              labelText: 'Meeting Title',
              icon: Icons.title,
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              controller: zoomLinkController,
              labelText: 'Zoom Link',
              icon: Icons.link,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
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
                backgroundColor: Colors.blue, // Button color
                padding: EdgeInsets.symmetric(vertical: 16), // Adjust the padding
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Adjust the text size and weight
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
              child: Text('Share Via WhatsApp'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, // Button color
                padding: EdgeInsets.symmetric(vertical: 16), // Adjust the padding
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Adjust the text size and weight
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
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
