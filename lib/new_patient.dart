import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'camera_screen1.dart';
import 'database_helper.dart'; // Import your database helper

class NewPatient extends StatefulWidget {
  @override
  _NewPatientState createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController jobDateController = TextEditingController();

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

  Future<void> saveInSqliteDatabase(String id, String date) async {
    await DatabaseHelper.instance.createPatient(id, date);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data Saved Successfully')),
    );
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen1())
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        jobDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate); // Format the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Patient'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextField(
                controller: patientIdController,
                decoration: InputDecoration(labelText: 'Patient ID'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextField(
                controller: jobDateController,
                decoration: InputDecoration(
                  labelText: 'Date Of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String id = patientIdController.text;
                String date = jobDateController.text;

                if (id.isEmpty || date.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please don\'t leave any fields empty')),
                  );
                } else {
                  saveInSqliteDatabase(id, date);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
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
                backgroundColor: Colors.blue,
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
