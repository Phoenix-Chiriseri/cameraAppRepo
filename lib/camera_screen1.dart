import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:async';
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
  bool _isSepia = false; // To toggle sepia filter

  Timer? _timer;
  int _start = 60; // Countdown starts from 60 seconds

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startTimer();
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
    _timer?.cancel();
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

  // Start the countdown timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _takePicture(); // Take picture when countdown reaches zero
        _timer?.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  // Toggle the sepia filter
  void _toggleSepiaFilter() {
    setState(() {
      _isSepia = !_isSepia;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text('Presaline')),
      body: GestureDetector(
        onScaleUpdate: _onScaleUpdate,
        child: Stack(
          children: [
            Center(
              child: ColorFiltered(
                colorFilter: _isSepia
                    ? ColorFilter.mode(
                  Colors.brown.withOpacity(0.5),
                  BlendMode.darken,
                )
                    : ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.multiply,
                ),
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Time remaining: $_start seconds',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                          MaterialPageRoute(builder: (context) => CameraScreen2()),
                        );
                      },
                      child: Text('Next'),
                    ),
                    ElevatedButton(
                      onPressed: _toggleSepiaFilter,
                      child: Text('Sepia Filter'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
