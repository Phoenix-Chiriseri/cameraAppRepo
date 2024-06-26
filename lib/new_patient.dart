import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'database_helper.dart'; // Import the database helper
import 'camera_screen1.dart'; // Import the camera screen

class NewPatient extends StatefulWidget {
  @override
  _NewPatientState createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  final TextEditingController patientIdController = TextEditingController();
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobDateController = TextEditingController();
  String? gender;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.contacts,
      Permission.camera,
    ].request();
  }

  Future<void> saveInSqliteDatabase(String id, String name, String date, String? gender) async {
    final patient = {
      'id': id,
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
              controller: patientIdController,
              decoration: InputDecoration(labelText: 'Patient ID'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: jobNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: jobDateController,
              decoration: InputDecoration(labelText: 'Date Of Birth'),
            ),
            SizedBox(height: 12.0),
            Center(
              child: DropdownButton<String>(
                value: gender,
                items: ['Male', 'Female'].map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue;
                  });
                },
                hint: Text('Gender'),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String id = patientIdController.text;
                String name = jobNameController.text;
                String date = jobDateController.text;

                if (id.isEmpty || name.isEmpty || date.isEmpty || gender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please don\'t leave any fields empty')),
                  );
                } else {
                  saveInSqliteDatabase(id, name, date, gender);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Save', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Back', style: TextStyle(fontSize: 16)),
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
