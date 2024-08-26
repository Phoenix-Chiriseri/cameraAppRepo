import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class CameraExample extends StatefulWidget {
  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  XFile? _image;
  List<dynamic>? _recognitions;

  @override
  void initState() {
    super.initState();
    requestPermission();
    loadModel();
  }

  Future<void> requestPermission() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> loadModel() async {
    String? results = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
    print(results);
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
      classifyImage(File(selectedImage.path));
    }
  }

  Future<void> classifyImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image Classification',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_image != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    File(_image!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue.withOpacity(0.2),
                  border: Border.all(color: Colors.blue.withOpacity(0.5)),
                ),
                child: Center(
                  child: Text(
                    'Image Preview',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              'Results',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            if (_recognitions != null)
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _recognitions!.map((res) {
                    return Text(
                      "${res["label"]}: ${(res["confidence"] * 100).toStringAsFixed(0)}%",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                pickImage(ImageSource.camera);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: TextStyle(fontSize: 16), // Text style for font size
                foregroundColor: Colors.white, // Sets the text color to white
              ),
              child: Text('Take Photo'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                pickImage(ImageSource.gallery);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Button background color
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding inside the button
                textStyle: TextStyle(fontSize: 16), // Text style for font size
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('Pick From Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CameraExample(),
  ));
}
