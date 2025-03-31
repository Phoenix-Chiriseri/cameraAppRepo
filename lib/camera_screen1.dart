import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';
import 'dart:typed_data';
import 'camera_screen2.dart'; // Import CameraScreen2

void main() {
  runApp(const MaterialApp(
    home: CameraScreen1(),
  ));
}

class CameraScreen1 extends StatefulWidget {
  const CameraScreen1({super.key});

  @override
  _CameraScreen1State createState() => _CameraScreen1State();
}

class _CameraScreen1State extends State<CameraScreen1> {
  CameraController? _rearCameraController;
  CameraController? _frontCameraController;
  List<CameraDescription>? _cameras;
  CameraDescription? _rearCamera;
  CameraDescription? _frontCamera;
  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;
  String? _capturedImagePath;

  late final encrypt.Key key;
  late final encrypt.Encrypter encrypter;

  @override
  void initState() {
    super.initState();
    key = encrypt.Key.fromLength(32); // Generate a secure key
    encrypter = encrypt.Encrypter(encrypt.AES(key));
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No cameras found'),
        ));
        return;
      }

      _rearCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => throw StateError('No rear camera found'));

      _frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => throw StateError('No front camera found'));

      _rearCameraController = CameraController(
        _rearCamera!,
        ResolutionPreset.high,
      );

      _frontCameraController = CameraController(
        _frontCamera!,
        ResolutionPreset.low,
      );

      await Future.wait([
        _rearCameraController!.initialize(),
        _frontCameraController!.initialize(),
      ]);

      // Get the min and max zoom levels
      _minZoomLevel = await _rearCameraController!.getMinZoomLevel();
      _maxZoomLevel = await _rearCameraController!.getMaxZoomLevel();

      if (!mounted) return; // Check if the widget is still in the tree

      setState(() {});
    } catch (e) {
      print('Error initializing cameras: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error initializing cameras: $e'),
      ));
    }
  }

  @override
  void dispose() {
    _rearCameraController?.dispose();
    _frontCameraController?.dispose();
    super.dispose();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentZoomLevel = (_currentZoomLevel * details.scale)
          .clamp(_minZoomLevel, _maxZoomLevel);
      _rearCameraController?.setZoomLevel(_currentZoomLevel);
    });
  }

  Future<void> _takePicture() async {
    if (_rearCameraController == null ||
        !_rearCameraController!.value.isInitialized) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    // Removed unused picturePath variable

    try {
      XFile picture = await _rearCameraController!.takePicture();
      final bytes = await picture.readAsBytes();

      // Generate a random IV
      final iv = encrypt.IV.fromLength(16);
      final encryptedData = encrypter.encryptBytes(bytes, iv: iv);

      // Store the IV along with the encrypted data
      final encryptedPicturePath = path.join(
        directory.path,
        '${DateTime.now().toIso8601String()}.enc',
      );

      final file = File(encryptedPicturePath);
      await file.writeAsBytes(
        Uint8List.fromList(iv.bytes + encryptedData.bytes),
      );

      setState(() {
        _capturedImagePath = encryptedPicturePath;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Encrypted picture saved to $encryptedPicturePath'),
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
    if (_rearCameraController == null ||
        !_rearCameraController!.value.isInitialized ||
        _frontCameraController == null ||
        !_frontCameraController!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Clean Cervix with Saline')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Clean Cervix with Saline')),
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(
                _rearCameraController!), // Main rear camera preview
          ),
          Positioned(
            bottom: 10,
            right: 10,
            width: 100,
            height: 100,
            child: CameraPreview(
                _frontCameraController!), // Miniature front camera preview
          ),
          GestureDetector(
            onScaleUpdate: _onScaleUpdate,
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          if (_capturedImagePath != null)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Image.file(File(_capturedImagePath!)),
              ),
            ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraScreen2()),
              );
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
