import 'package:flutter/material.dart';

class PatientHistory extends StatelessWidget {
  const PatientHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient History'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Add widgets to display patient history here
            // For example, you can use ListView to display a list of past appointments or medical records
            Expanded(
              child: ListView(
                children: const [
                  // Card 1
                  Card(
                    elevation: 3, // Add elevation for a raised effect
                    margin: EdgeInsets.only(
                        bottom: 16.0), // Add margin between cards
                    child: ListTile(
                      title: Text('Appointment Date: January 5, 2023'),
                      subtitle: Text('Reason for Visit: Follow-up checkup'),
                    ),
                  ),
                  // Card 2
                  Card(
                    elevation: 3, // Add elevation for a raised effect
                    margin: EdgeInsets.only(
                        bottom: 16.0), // Add margin between cards
                    child: ListTile(
                      title: Text('Appointment Date: March 12, 2023'),
                      subtitle: Text('Reason for Visit: Flu symptoms'),
                    ),
                  ),
                  // Add more cards as needed
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement functionality to navigate back to the previous screen
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Change the background color to green
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // Adjust the padding
                textStyle:
                    const TextStyle(fontSize: 12), // Adjust the text size
              ),
              child: const Text('Back',
                  style: TextStyle(fontSize: 12)), // Adjust the text size
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PatientHistory(),
  ));
}
