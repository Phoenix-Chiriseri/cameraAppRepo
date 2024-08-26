import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:simple_project/widgets/inputTextWidget.dart';
import 'package:simple_project/signUpScreen.dart';
import 'package:simple_project/new_dash.dart';
import 'package:simple_project/database_helper.dart';
import 'package:simple_project/camera_screen1.dart';
import 'package:permission_handler/permission_handler.dart'; // Import for permissions

void main() {
  runApp(MaterialApp(
    home: NewPatient(),
  ));
}

class NewPatient extends StatefulWidget {
  @override
  _NewPatientState createState() => _NewPatientState();
}

class _NewPatientState extends State<NewPatient> {
  final TextEditingController patientIdController = TextEditingController();
  final TextEditingController jobDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            backgroundColor: Color(0xFFdccdb4),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.asset("assets/ndandi.jpg", fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Color(0xFFdccdb4), Color(0xFFd8c3ab)]
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputTextWidget(
                          controller: patientIdController,
                          labelText: "Enter Patient Id",
                          icon: Icons.person, // Updated icon
                          obscureText: false,
                          keyboardType: TextInputType.text,
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: InputTextWidget(
                            controller: jobDateController,
                            labelText: "Enter Date Of Birth",
                            icon: Icons.calendar_today,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          height: 55.0,
                          child: ElevatedButton(
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
                              backgroundColor: Colors.red,
                              elevation: 0.0,
                              minimumSize: Size(screenWidth * 0.8, 55), // Adjusted size
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            child: Text(
                              "Save Patient",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 0),
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                width: (screenWidth / 2) - 40,
                                height: 55,
                                child: Material(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: InkWell(
                                    onTap: () {
                                      print("facebook tapped");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/fb.png", fit: BoxFit.cover),
                                          SizedBox(width: 7.0),
                                          Text("Sign in with\nFacebook")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 30.0, top: 15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 0),
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                width: (screenWidth / 2) - 40,
                                height: 55,
                                child: Material(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: InkWell(
                                    onTap: () {
                                      print("google tapped");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image.asset("assets/google.png", fit: BoxFit.cover),
                                          SizedBox(width: 7.0),
                                          Text("Sign in with\nGoogle")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
