import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize timezone data
  tz.initializeTimeZones();

  runApp(const MaterialApp(
    home: MedicationForm(),
  ));
}

class MedicationForm extends StatefulWidget {
  const MedicationForm({super.key});

  @override
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedType = 'mg';
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _types = ['mg', 'g', 'ml', 'units'];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    // Initialize the local notifications plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(String medicationName, TimeOfDay time) async {
    final now = DateTime.now();
    final notificationTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Convert DateTime to TZDateTime
    final tz.TZDateTime tzNotificationTime = tz.TZDateTime.from(notificationTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time to take your medication!',
      'It\'s time to take $medicationName.',
      tzNotificationTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_reminder_channel', // Channel ID
          'Medication Reminders', // Channel Name
          channelDescription: 'This channel is used for medication reminders',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Pill Name'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _selectedType,
              items: _types.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const Center(
              child: Text(
                'Select time to remind you to take your medication:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (pickedTime != null && pickedTime != _selectedTime) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                minimumSize: const Size(double.infinity, 60), // Button size
              ),
              child: Text('Select Time: ${_selectedTime.format(context)}'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final medication = {
                  'name': _nameController.text,
                  'amount': int.parse(_amountController.text),
                  'type': _selectedType,
                  'time': _selectedTime.format(context),
                };

                try {
                  await DatabaseHelper.instance.createMedication(
                    medication['name'] as String,
                    medication['amount'] as int,
                    medication['type'] as String,
                    medication['time'] as String,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Medication saved successfully!'),
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Schedule the notification
                  await _scheduleNotification(medication['name'] as String, _selectedTime);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error saving medication: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                minimumSize: const Size(double.infinity, 60), // Button size
              ),
              child: const Text('Save Medication'),
            ),
          ],
        ),
      ),
    );
  }
}
