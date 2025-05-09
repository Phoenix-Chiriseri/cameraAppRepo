import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simple_project/new_dash.dart';
import 'package:simple_project/widgets/text_widget.dart';
import 'package:simple_project/database_helper.dart';

void main() {
  runApp(const MaterialApp(
    home: SeeAll(),
  ));
}

class SeeAll extends StatefulWidget {
  const SeeAll({super.key});

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  var opacity = 0.0;
  bool position = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  animator() {
    setState(() {
      opacity = opacity == 1 ? 0 : 1;
      position = !position;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchPatients() async {
    return await DatabaseHelper.instance.getAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 70),
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: position ? 1 : 50,
              left: 20,
              right: 20,
              child: upperRow(),
            ),
            AnimatedPositioned(
                top: position ? 60 : 120,
                right: 20,
                left: 20,
                duration: const Duration(milliseconds: 300),
                child: findDoctor()),
            AnimatedPositioned(
                top: position ? 390 : 450,
                right: 20,
                left: 20,
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 400),
                  child: Container(width: size.width),
                )),
            AnimatedPositioned(
                top: position ? 430 : 500,
                left: 20,
                right: 20,
                duration: const Duration(milliseconds: 500),
                child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: opacity,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchPatients(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No patients found.'));
                        }

                        final patients = snapshot.data!;

                        return SizedBox(
                          height: 350,
                          child: ListView.builder(
                            itemCount: patients.length,
                            itemBuilder: (context, index) {
                              final patient = patients[index];
                              return InkWell(
                                onTap: () async {
                                  animator();
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  animator();
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    height: 120,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.black,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextWidget(
                                              'Patient ID: ${patient['id']}',
                                              12,
                                              Colors.black,
                                              FontWeight.bold,
                                              letterSpace: 0,
                                            ),
                                            const SizedBox(height: 5),
                                            TextWidget(
                                              'Date of Birth: ${patient['date_of_birth']}',
                                              12,
                                              Colors.black,
                                              FontWeight.bold,
                                              letterSpace: 0,
                                            ),
                                            const SizedBox(height: 5),
                                          ],
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.navigation_sharp,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ))),
          ],
        ),
      ),
    );
  }

  Widget findDoctor() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: opacity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.black,
                  ])),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 25,
                  left: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Center(
                          child: Image(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/doctor3.png'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          TextWidget(
                            "Patient List!",
                            14,
                            Colors.white,
                            FontWeight.bold,
                            letterSpace: 0,
                          ),
                          const SizedBox(height: 5),
                          TextWidget(
                            "This is the list of patients \n in your database",
                            12,
                            Colors.white,
                            FontWeight.normal,
                            letterSpace: 0,
                          ),
                        ],
                      )
                    ],
                  )),
              Positioned(
                  top: 115,
                  left: 20,
                  right: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/doctor3.png'))),
                    ),
                  )),
              const Positioned(
                  top: 15,
                  right: 15,
                  child: Icon(
                    Icons.close_outlined,
                    color: Colors.white,
                    size: 15,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget upperRow() {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              animator();
              Timer(const Duration(milliseconds: 600), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ));
              });
            },
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
              size: 25,
            ),
          ),
          TextWidget("", 25, Colors.black, FontWeight.bold),
          const Icon(
            Icons.search,
            color: Colors.black,
            size: 25,
          )
        ],
      ),
    );
  }
}
