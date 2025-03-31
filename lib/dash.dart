import 'package:flutter/material.dart';
import 'package:simple_project/widgets/inputTextWidget.dart';
import 'package:simple_project/signUpScreen.dart';
import 'package:simple_project/new_dash.dart';
import 'package:simple_project/database_helper.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

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
            backgroundColor: const Color(0xFFdccdb4),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.asset("assets/ndandi.jpg", fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Color(0xFFdccdb4), Color(0xFFd8c3ab)])),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputTextWidget(
                              controller: _emailController,
                              labelText: "Email",
                              icon: Icons.email,
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress),
                          InputTextWidget(
                              controller: _pwdController,
                              labelText: "Password",
                              icon: Icons.lock,
                              obscureText: true,
                              keyboardType: TextInputType.text),
                          Padding(
                            padding: const EdgeInsets.only(right: 25.0, top: 10.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                    ),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            child: ElevatedButton(
                              onPressed: () async {
                                final email = _emailController.text;
                                final password = _pwdController.text;

                                bool isValid = await _dbHelper.validateUser(email, password);
                                if (isValid) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Home()),
                                  );
                                } else {
                                  // Show an error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Invalid email or password')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0.0,
                                minimumSize: Size(screenWidth, 150),
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(0)),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.red,
                                          offset: Offset(1.1, 1.1),
                                          blurRadius: 10.0),
                                    ],
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Sign In",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            height: 55.0,
                            width: screenWidth - 60, // Adjust width to fit nicely
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Change to your preferred color
                                elevation: 0.0,
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                              child: const Text(
                                "Register",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 10.0, top: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 5.0),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0)),
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
                                    const SizedBox(
                                      width: 7.0,
                                    ),
                                    const Text("Sign in with\nfacebook")
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
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 5.0),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0)),
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
                                    const SizedBox(
                                      width: 7.0,
                                    ),
                                    const Text("Sign in with\nGoogle")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Colors.white,
        child: Center(
            child: Wrap(
              children: [
                Text(
                  "Forgot Password?  ",
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.bold),
                ),
                Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
