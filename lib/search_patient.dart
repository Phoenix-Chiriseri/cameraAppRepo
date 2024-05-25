import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'database_helper.dart';

class SearchPatient extends StatefulWidget {
  @override
  _SearchPatientState createState() => _SearchPatientState();
}

class _SearchPatientState extends State<SearchPatient> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      await Permission.contacts.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Patient'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Patient Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: dobController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                searchPatient(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Change the background color to green
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust the padding
                textStyle: TextStyle(fontSize: 16), // Adjust the text size
              ),
              child: Text('Search Patient'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> searchPatient(BuildContext context) async {
    String name = nameController.text;
    String dob = dobController.text;
    String phoneNumber = phoneNumberController.text;

    final results = await DatabaseHelper.instance.searchPatients(name, dob, phoneNumber);

    if (results.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Patient Found'),
            content: Text('No patient found with the provided details.'),
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
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var patient in results)
                  ListTile(
                    title: Text('Name: ${patient['name']}'),
                    subtitle: Text('DOB: ${patient['date']}, Phone: ${patient['phoneNumber']}'),
                  ),
              ],
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
}

void main() {
  runApp(MaterialApp(
    home: SearchPatient(),
  ));
}
