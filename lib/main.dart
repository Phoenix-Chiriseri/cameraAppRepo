import 'package:flutter/material.dart';
import 'package:simple_project/widgets/inputTextWidget.dart';
import 'package:simple_project/signUpScreen.dart';
import 'package:simple_project/new_dash.dart';
import 'package:simple_project/database_helper.dart'; // Import the database helper

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  LoginScreen() : super();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // Initialize DatabaseHelper

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double r = (175 / 360); // Ratio for web test
    final coverHeight = screenWidth * r;

    final widgetList = [
      Row(
        children: [
          SizedBox(width: 28),
          Text(
            'Welcome',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: const Color(0xff000000),
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      SizedBox(height: 12.0),
      Form(
        key: _formKey,
        child: Column(
          children: [
            InputTextWidget(
              controller: _emailController,
              labelText: "Email",
              icon: Icons.email,
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12.0),
            InputTextWidget(
              controller: _pwdController,
              labelText: "Password",
              icon: Icons.lock,
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
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
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              height: 55.0,
              child: ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text;
                  final password = _pwdController.text;

                  bool isValid = await _dbHelper.validateUser(email, password);
                  if (isValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid email or password')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  minimumSize: Size(screenWidth, 55),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.red,
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0,
                      ),
                    ],
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Sign In",
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
                    offset: const Offset(0, 0),
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
                        Text("Sign in with\nfacebook"),
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
                    offset: const Offset(0, 0),
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
                        Text("Sign in with\nGoogle"),
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
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: coverHeight - 25,
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
                  colors: <Color>[Color(0xFFdccdb4), Color(0xFFd8c3ab)],
                ),
              ),
              width: screenWidth,
              height: 25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: screenWidth,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(30.0),
                        topRight: const Radius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return widgetList[index];
              },
              childCount: widgetList.length,
            ),
          ),
        ],
      ),
    );
  }
}
