import 'package:flutter/material.dart';
import 'package:simple_project/widgets/inputTextWidget.dart';
import 'package:simple_project/database_helper.dart'; // Import the database helper

void main() {
  runApp(const MaterialApp(
    home: SearchPatient(),
  ));
}

class SearchPatient extends StatefulWidget {
  const SearchPatient({super.key});

  @override
  _SearchPatientState createState() => _SearchPatientState();
}

class _SearchPatientState extends State<SearchPatient> {
  final TextEditingController idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _searchPatient(BuildContext context) async {
    final id = idController.text;
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a patient ID')),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Searching...'),
          content: CircularProgressIndicator(),
        );
      },
    );

    try {
      final results = await DatabaseHelper.instance.searchPatientsById(id);
      Navigator.of(context).pop(); // Close the loading dialog

      if (results.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No Patient Found'),
              content: const Text('No patient found with the provided ID.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Search Results'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var patient in results)
                      ListTile(
                        title: Text('ID: ${patient['id']}'),
                        subtitle: Text('Name: ${patient['name']}, Date: ${patient['date']}'),
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double r = (175 / 360); // Ratio for web test
    final coverHeight = screenWidth * r;

    final buttonWidth = screenWidth * 0.8; // Make buttons a bit smaller than screen width
    const buttonHeight = 55.0; // Set a consistent height for buttons

    final widgetList = [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Search Patient',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff000000),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputTextWidget(
                controller: idController,
                labelText: "Enter Patient Id",
                icon: Icons.person, // Updated icon
                obscureText: false,
                keyboardType: TextInputType.text,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    _searchPatient(context);
                  },
                  child: const Text("Search Patient"),
                ),
              ),
              const SizedBox(height: 8.0), // Reduced space between buttons
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical margin
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Back navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0.0,
                    minimumSize: Size(buttonWidth, buttonHeight),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
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
            backgroundColor: const Color(0xFFdccdb4),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Image.asset("assets/patient.jpg", fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
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
