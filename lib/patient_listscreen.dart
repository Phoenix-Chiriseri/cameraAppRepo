import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper

void main() {
  runApp(PatientListScreen());
}

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  Future<List<Map<String, dynamic>>> _fetchPatients() async {
    return await DatabaseHelper.instance.getAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Patients'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No patients found.'));
          }

          final patients = snapshot.data!;

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text('Patient ID: ${patient['id']}'),
                  subtitle: Text('Date of Birth: ${patient['date_of_birth']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
