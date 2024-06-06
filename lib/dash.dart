import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'new_patient.dart';
import 'patient_history.dart';
import 'search_patient.dart';
import 'camera_example.dart';
import 'camera_example2.dart';

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
    'assets/medical.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UZ Project App'),
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
            imageAsset: 'assets/viewImages.png',
            title: 'Test Camera',
            subtitle: 'Connect Application To External Camera',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraExample2()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // The phone number to call for enquiries
          final phoneNumber = "+263771255849";
          FlutterPhoneDirectCaller.callNumber(phoneNumber);
        },
        tooltip: 'Call',
        child: Icon(Icons.phone),
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
