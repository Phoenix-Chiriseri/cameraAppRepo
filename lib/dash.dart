import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_project/google_meet.dart';
import 'package:simple_project/new_patient.dart';
import 'package:simple_project/patient_history.dart';
import 'package:simple_project/search_patient.dart';
import 'package:simple_project/camera_example.dart';
import 'package:simple_project/telemedicine.dart';
import 'package:simple_project/medication_form.dart';
import 'package:simple_project/teams_test.dart';
import 'package:simple_project/start_zoom.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    //iOS: IOSInitializationSettings(),
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showContacts() async {
    var permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Contact'),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts.elementAt(index);
                  return ListTile(
                    title: Text(contact.displayName ?? ''),
                    subtitle: contact.phones!.isEmpty
                        ? Text('No phone number available')
                        : Text(contact.phones!.first.value ?? ''),
                    onTap: () {
                      Navigator.pop(context);
                      if (contact.phones!.isNotEmpty) {
                        _makePhoneCall(contact.phones!.first.value ?? '');
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access contacts is denied')),
      );
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MedStake'),
        backgroundColor: Colors.blue,
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
                MaterialPageRoute(builder: (context) => ShareZoomLink()),
              );
            },
          ),
          CustomCard(
            imageAsset: 'assets/viewImages.png',
            title: 'Review Images',
            subtitle: 'View images about your patients',
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
            subtitle: 'Connect to Google Meet and start meeting',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoogleMeet()),
              );
            },
          ),
          CustomCard(
            imageAsset: 'assets/googleMeetIcon.jpeg',
            title: 'Start Teams Meeting',
            subtitle: 'Connect to a Teams meeting',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeamsHandler()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 80,
            right: 20,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GoogleMeetsApp()),
                  );
                },
                tooltip: 'Start Meeting',
                child: Icon(Icons.tv_outlined),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _showContacts,
              tooltip: 'Call Patient',
              child: Icon(Icons.contacts),
              backgroundColor: Colors.green,
            ),
          ),
        ],
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
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListTile(
          leading: Image.asset(imageAsset),
          title: Text(
            title,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          onTap: onTap,
        ),
      ),
    );
  }
}
