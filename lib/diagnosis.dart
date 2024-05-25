import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the database helper
import 'camera_screen1.dart'; // Import the camera screen
import 'dash.dart';

class Diagnosis extends StatefulWidget {
  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveInSqliteDatabase(String name, String date) async {
    final patient = {
      'name': name,
      'date': date,
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
        title: Text('Diagnosis'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: jobNameController,
              decoration: InputDecoration(
                labelText: 'Diagnosis',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: jobDateController,
              decoration: InputDecoration(
                labelText: 'Treatment',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
              maxLines: 5, // Make the text field bigger
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String name = jobNameController.text;
                String date = jobDateController.text;

                if (name.isEmpty || date.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please Don\'t Leave Any Empty Fields')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Diagnosis Saved')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 16), // Increased text size
              ),
              child: Text('Save', style: TextStyle(fontSize: 16)), // Increased text size
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 16), // Increased text size
              ),
              child: Text('Back', style: TextStyle(fontSize: 16)), // Increased text size
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Diagnosis(),
  ));
}
