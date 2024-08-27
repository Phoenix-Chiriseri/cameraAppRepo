import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_project/widgets/inputTextWidget.dart';
import 'package:simple_project/new_patient.dart';
import 'package:simple_project/telemedicine.dart';
import 'package:simple_project/search_patient.dart';
import 'package:simple_project/apply_iodine.dart';
import 'package:simple_project/camera_example.dart';
import 'package:simple_project/teams_test.dart';
import 'package:simple_project/camera_example.dart';
import 'package:simple_project/new_dash.dart';
import 'package:simple_project/about.dart';
import 'package:simple_project/start_googlemeet.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    GoogleMeetIntegrationApp()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFD8D9EC),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Welcome To Medstake',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
                    ),
                    Spacer(),
                    Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 18,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg?size=626&ext=jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
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
                                  fontWeight: FontWeight.w300),
                            ),
                            Spacer(),
                            Text(
                              'Ai Powered',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Medstake isn't just about technology; we infuse it with empathy. Our AI doctors don't replace the human touch; they enhance it.",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                  child: Icon(
                                    Icons.play_arrow,
                                    size: 14,
                                    color: Colors.black,
                                  )),
                            ),
                            Spacer(),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg?size=626&ext=jpg'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8ZmFjZSUyMHBvcnRyYWl0fGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://images.unsplash.com/photo-1595152452543-e5fc28ebc2b8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8bWVuJTIwcG9ydHJhaXR8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                  child: Text(
                                    '+17',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCard(
                      context,
                      title: 'Save Patient',
                      description: 'Create A New Patient And Save',
                      label: 'Health',
                      rating: '5.0',
                      color: Colors.black,
                      textColor: Colors.white,
                      isNew: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewPatient()),
                        );
                      },
                    ),
                    _buildCard(
                      context,
                      title: 'Search Patient',
                      description: 'Search A Patient And View Information',
                      label: 'Self Education',
                      color: Colors.white70,
                      textColor: Colors.black,
                      isNew: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPatient()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCard(
                      context,
                      title: 'Telemedicine',
                      description: 'Share a meeting link via whatsapp and allow users to join',
                      label: 'Health',
                      rating: '5.0',
                      color: Colors.black,
                      textColor: Colors.white,
                      isNew: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Telemedicine()),
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
                          MaterialPageRoute(builder: (context) => CameraExample()),
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
            duration: Duration(milliseconds: 500),
            opacity: 1.0, // Set to 0.0 for invisible or 1.0 for visible
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoogleMeetIntegrationApp()),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.video_call),
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
            selectedItemColor: Colors.black, // Set the color of the selected item to black
            unselectedItemColor: Colors.black.withOpacity(0.6), // Set the color of unselected items to black with reduced opacity
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
            color: color, borderRadius: BorderRadius.circular(12)),
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
                        fontWeight: FontWeight.w300),
                  ),
                  Spacer(),
                  if (isNew)
                    Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        'NEW',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  if (rating != null)
                    Text(
                      rating,
                      style: TextStyle(
                          color: Colors.yellow.shade500,
                          fontSize: 10,
                          fontWeight: FontWeight.w300),
                    ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                    color: textColor, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
