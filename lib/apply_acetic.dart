import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';
import 'dart:typed_data';
// Import CameraScreen2
import 'package:simple_project/apply_iodine.dart';

class ApplyAcetic extends StatefulWidget {
  const ApplyAcetic({super.key});

  @override
  _ApplyAceticState createState() => _ApplyAceticState();
}

class _ApplyAceticState extends State<ApplyAcetic> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  CameraDescription? firstCamera;
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
    // Removed unused picturePath variable

    try {
      XFile picture = await _controller!.takePicture();
      final bytes = await picture.readAsBytes();

      // Generate a random IV
      final iv = encrypt.IV.fromLength(16);
      final encryptedData = encrypter.encryptBytes(bytes, iv: iv);

      // Store the IV along with the encrypted data
      final encryptedPicturePath = path.join(
        directory.path,
        '${DateTime.now()}.enc',
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
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Apply Acetic Acid')),
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
                            decoration: const BoxDecoration(
                              color: Colors.blue,
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
                      margin: const EdgeInsets.all(8.0),
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
                  child: const Icon(Icons.camera),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ApplyIodine()),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
