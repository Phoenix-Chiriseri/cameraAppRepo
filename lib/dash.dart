import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_project/google_meet.dart';
import 'new_patient.dart';
import 'patient_history.dart';
import 'search_patient.dart';
import 'camera_example.dart';
import 'telemedicine.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> imageList = [
    'assets/advice.png',
    'assets/diagnose.png',
    'assets/medical.png',
    'assets/zoom.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthCare Application'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          CustomCard(
            imageAsset: 'assets/advice.png',
            title: 'New Patient',
            subtitle: 'Add a new patient to your database and manage their information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewPatient()),
              );
            },
          ),
          CustomCard(
            imageAsset: 'assets/diagnose.png',
            title: 'Patient History',
            subtitle: 'Access and review patients medical history and past appointments',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientHistory()),
              );
            },
          ),
          CustomCard(
            imageAsset: 'assets/medical.png',
            title: 'Search Patient',
            subtitle: 'Quickly find specific patients by name or other criteria and manage their records',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPatient()),
              );
            },
          ),
          CustomCard(
            imageAsset: 'assets/telemedicine.png',
            title: 'TeleMedicine',
            subtitle: 'Connect instantly, manage records efficiently, and provide personalized care from anywhere.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelemedicineScreen()),
              );
            },
          ),
          CustomCard(
            imageAsset: 'assets/viewImages.png',
            title: 'Review Images',
            subtitle: 'View Images About Your Patients',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraExample()),
              );
            },
          ),
          CustomCard(
            imageAsset: 'assets/googleMeetIcon.jpeg',
            title: 'View Google Meet Meeting',
            subtitle: 'Connect to Google Meet and Start Meeting',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoogleMeet()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //click the floating action button to start the zoom call..
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GoogleMeet()),
          );
        },
        tooltip: 'Start Meeting',
        child: Icon(Icons.no_meeting_room_rounded),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  CustomCard({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Add elevation for a raised effect
      margin: EdgeInsets.only(bottom: 16.0), // Add margin between cards
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding inside the card
        child: ListTile(
          leading: Image.asset(imageAsset),
          title: Text(
            title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle), // Add subtitle text
          onTap: onTap,
        ),
      ),
    );
  }
}


