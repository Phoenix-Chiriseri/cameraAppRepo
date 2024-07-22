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
  //function that loads the model
  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
    print(res);
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
      numResults: 1, // Adjusted to 1 for a binary classification model
      threshold: 0.5, // Adjust this based on your model
      imageMean: 127.5, // Adjust this based on your model
      imageStd: 127.5, // Adjust this based on your model
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 200,
              ),
            if (_image == null)
              Placeholder(
                fallbackHeight: 200,
                color: Colors.grey,
              ),
            SizedBox(height: 16.0),
            Text(
              'Results',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (_recognitions != null)
              ..._recognitions!.map((res) {
                return Text(
                  "${res["label"]}: ${(res["confidence"] * 100).toStringAsFixed(0)}%",
                  style: TextStyle(fontSize: 20),
                );
              }).toList(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                pickImage(ImageSource.camera);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text('Take Photo'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                pickImage(ImageSource.gallery);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 16),
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
