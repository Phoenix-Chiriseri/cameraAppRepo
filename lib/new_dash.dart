import 'package:flutter/material.dart';
import 'package:simple_project/new_patient.dart';
import 'package:simple_project/telemedicine.dart';
import 'package:simple_project/search_patient.dart';
import 'package:simple_project/camera_example.dart';
import 'package:simple_project/start_googlemeet.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // Removed unused '_screens' field

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFD8D9EC),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Welcome To ColpoPen',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 18,
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/main-doctor.jpg'), // Updated to use AssetImage
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'AI Powered',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "ColpoPen is an AI-powered portable colposcopy device. Be sure to maintain patient privacy when using this device.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        // Removed image display section
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCard(
                      context,
                      title: 'Start Exam',
                      description: 'Create A New Patient And Save',
                      label: 'Health',
                      rating: '5.0',
                      color: Colors.black,
                      textColor: Colors.white,
                      isNew: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NewPatient()),
                        );
                      },
                    ),
                    _buildCard(
                      context,
                      title: 'Previous Exams',
                      description: 'Search A Patient And View Information',
                      label: 'Self Education',
                      color: Colors.white70,
                      textColor: Colors.black,
                      isNew: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchPatient()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCard(
                      context,
                      title: 'Add Participants',
                      description:
                          'Share a meeting link via WhatsApp and allow users to join',
                      label: 'Health',
                      rating: '5.0',
                      color: Colors.black,
                      textColor: Colors.white,
                      isNew: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Telemedicine()),
                        );
                      },
                    ),
                    _buildCard(
                      context,
                      title: 'Upload Images',
                      description: 'Upload images and test via AI',
                      label: 'Self Education',
                      color: Colors.white70,
                      textColor: Colors.black,
                      isNew: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraExample()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Tooltip(
          message: 'Start meeting',
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0, // Set to 0.0 for invisible or 1.0 for visible
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GoogleMeetIntegrationPage()),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.video_call),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home), // Home icon
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info), // About icon
              label: 'About',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white, // Set the background color to white
          selectedItemColor:
              Colors.black, // Set the color of the selected item to black
          unselectedItemColor: Colors.black.withOpacity(
              0.6), // Set the color of unselected items to black with reduced opacity
          elevation: 10, // Adds shadow for better visibility
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String description,
    required String label,
    String? rating,
    required Color color,
    required Color textColor,
    bool isNew = false,
    required Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  if (isNew)
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  if (rating != null)
                    Text(
                      rating,
                      style: TextStyle(
                        color: Colors.yellow.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
