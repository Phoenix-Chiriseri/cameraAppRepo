import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:simple_project/apply_acetic.dart';
import 'dart:io';
import 'camera_screen2.dart'; // Import CameraScreen2

class CameraScreen1 extends StatefulWidget {
  @override
  _CameraScreen1State createState() => _CameraScreen1State();
}

class _CameraScreen1State extends State<CameraScreen1> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  CameraDescription? firstCamera;
  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras?.first;
    _controller = CameraController(
      firstCamera!,
      ResolutionPreset.high,
    );
    await _controller?.initialize();

    // Get the min and max zoom levels
    _minZoomLevel = await _controller!.getMinZoomLevel();
    _maxZoomLevel = await _controller!.getMaxZoomLevel();

    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentZoomLevel = (_currentZoomLevel * details.scale)
          .clamp(_minZoomLevel, _maxZoomLevel);
      _controller?.setZoomLevel(_currentZoomLevel);
    });
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final String picturePath = path.join(
      directory.path,
      '${DateTime.now()}.png',
    );

    try {
      XFile picture = await _controller!.takePicture();
      await picture.saveTo(picturePath);
      setState(() {
        _capturedImagePath = picturePath;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Picture saved to $picturePath'),
      ));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Apply Saline')),
      body: GestureDetector(
        onScaleUpdate: _onScaleUpdate,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CameraPreview(_controller!),
                        Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_capturedImagePath != null)
                    Container(
                      width: 100,
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Image.file(File(_capturedImagePath!)),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  child: Icon(Icons.camera),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ApplyAcetic()),
                    );
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
