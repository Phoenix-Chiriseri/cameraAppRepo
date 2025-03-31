import 'package:flutter/material.dart';
import 'package:simple_project/widgets/inputTextWidget.dart';
import 'package:simple_project/database_helper.dart';
import 'package:simple_project/new_dash.dart'; // Import your database helper
// Import the Home screen

void main() {
  runApp(const MaterialApp(
    home: SignUpScreen(),
  ));
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Segoe UI',
              fontSize: 30,
              shadows: [
                Shadow(
                  color: Color(0xba000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                )
              ],
            )),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context); // Go back
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  const Text(
                    'Register With Us!',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 25.0),
                  InputTextWidget(
                      controller: _nameController,
                      labelText: "Name",
                      icon: Icons.person,
                      obscureText: false,
                      keyboardType: TextInputType.text),
                  const SizedBox(height: 12.0),
                  InputTextWidget(
                      controller: _surnameController,
                      labelText: "Surname",
                      icon: Icons.person,
                      obscureText: false,
                      keyboardType: TextInputType.text),
                  const SizedBox(height: 12.0),
                  InputTextWidget(
                      controller: _emailController,
                      labelText: "Email",
                      icon: Icons.email,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12.0),
                  InputTextWidget(
                      controller: _phoneController,
                      labelText: "Telephone Number",
                      icon: Icons.phone,
                      obscureText: false,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Container(
                      child: Material(
                        elevation: 15.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(15.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, left: 15.0),
                          child: TextFormField(
                              obscureText: true,
                              controller: _pass,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.lock,
                                    color: Colors.black, size: 32.0),
                                labelText: "Password",
                                labelStyle: TextStyle(
                                    color: Colors.black54, fontSize: 18.0),
                                enabledBorder: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please provide a password';
                                } else if (val.length < 6) {
                                  return 'Password should be more than 6 characters';
                                }
                                return null;
                              }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Container(
                      child: Material(
                        elevation: 15.0,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(15.0),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, left: 15.0),
                          child: TextFormField(
                              obscureText: true,
                              controller: _confirmPass,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.lock,
                                    color: Colors.black, size: 32.0),
                                labelText: "Confirm Password",
                                labelStyle: TextStyle(
                                    color: Colors.black54, fontSize: 18.0),
                                enabledBorder: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54),
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (val) {
                                if (val!.isEmpty)
                                  return 'Confirm the password!!';
                                if (val != _pass.text)
                                  return 'Passwords do not match';
                                return null;
                              }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  SizedBox(
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _dbHelper.createUser(
                            _nameController.text,
                            _surnameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _pass.text,
                          );

                          // Navigate to Home screen without the user’s name
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0.0,
                        minimumSize: Size(screenWidth, 55),
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xfff05945),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                            color: const Color(0xffF05945),
                            borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Register",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
