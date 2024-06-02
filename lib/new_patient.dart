import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'database_helper.dart'; // Import the database helper
import 'camera_screen1.dart'; // Import the camera screen

class NewPatient extends StatefulWidget {
  @override
  _NewPatientState createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobDateController = TextEditingController();
  String? gender;

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

  Future<void> saveInSqliteDatabase(String name, String date, String? gender) async {
    final patient = {
      'name': name,
      'date': date,
      'gender': gender
    };

    await DatabaseHelper.instance.create(patient);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data Saved Successfully')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Patient'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: jobNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: jobDateController,
              decoration: InputDecoration(labelText: 'Date Of Birth'),
            ),
            Center(
              child: DropdownButton<String>(
                value: gender,
                items: ['Male', 'Female'].map((shift) {
                  return DropdownMenuItem<String>(
                    value: shift,
                    child: Text(shift),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    gender = value;
                  });
                },
                hint: Text('Gender'),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String name = jobNameController.text;
                String date = jobDateController.text;

                if (name.isEmpty || date.isEmpty || gender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please Don\'t Leave Any Empty Fields')),
                  );
                } else {
                  saveInSqliteDatabase(name, date, gender);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 12),
              ),
              child: Text('Save', style: TextStyle(fontSize: 12)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 12),
              ),
              child: Text('Back', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NewPatient(),
  ));
}