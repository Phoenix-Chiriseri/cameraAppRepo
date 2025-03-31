import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'camera_service.dart'; // Assuming this is a custom service you've created
import 'package:permission_handler/permission_handler.dart';

class CameraExample2 extends StatefulWidget {
  const CameraExample2({super.key});

  @override
  _CameraExample2State createState() => _CameraExample2State();
}

class _CameraExample2State extends State<CameraExample2> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  final CameraService _cameraService = CameraService('192.168.1.101');

  bool _isConnected = false;
  String _statusMessage = 'Connecting to Wi-Fi...';
  String? _cameraIP;

  @override
  void initState() {
    super.initState();
    _connectToWifi();
  }

  Future<void> _connectToWifi() async {
    try {
      // Request location permission
      if (await Permission.location.request().isGranted) {
        // Replace with your camera's Wi-Fi SSID and password
        const ssid = 'inskam-FC10E16';
        const password = '12345678';

        // Enable Wi-Fi if it's not enabled
        bool wifiEnabled = await WiFiForIoTPlugin.isEnabled();
        print('Wi-Fi enabled: $wifiEnabled');
        if (!wifiEnabled) {
          await WiFiForIoTPlugin.setEnabled(true);
          print('Wi-Fi has been enabled');
        }

        // Connect to the camera's Wi-Fi network
        bool isConnected = await WiFiForIoTPlugin.connect(
          ssid,
          password: password,
          joinOnce: true,
          security: NetworkSecurity.WPA,
        );

        if (isConnected) {
          print('Connected to Wi-Fi network $ssid');
          // Fetch the IP address of the connected Wi-Fi network
          final info = NetworkInfo();
          String? wifiIP = await info.getWifiIP();
          setState(() {
            _isConnected = true;
            _statusMessage = 'Connected to Wi-Fi';
            _cameraIP = wifiIP;
          });

          if (wifiIP != null) {
            print('Camera IP address: $wifiIP');
            _initializeVideoPlayer();
          } else {
            print('Failed to retrieve IP address');
            setState(() {
              _statusMessage = 'Connected to Wi-Fi\nFailed to retrieve IP address';
            });
          }
        } else {
          print('Failed to connect to Wi-Fi');
          setState(() {
            _statusMessage = 'Failed to connect to Wi-Fi';
          });
        }
      } else {
        print('Location permission denied');
        setState(() {
          _statusMessage = 'Location permission denied';
        });
      }
    } catch (e) {
      print('Error connecting to Wi-Fi: $e');
      setState(() {
        _statusMessage = 'Error connecting to Wi-Fi: $e';
      });
    }
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      String streamUrl = await _cameraService.getStreamUrl();
      print('Stream URL: $streamUrl');
      _controller = VideoPlayerController.network(streamUrl);
      _initializeVideoPlayerFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing video player: $e');
      setState(() {
        _statusMessage = 'Error initializing video player: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('External Camera Stream'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _isConnected
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _controller != null
                ? FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
                : const CircularProgressIndicator(),
            if (_cameraIP != null) Text('Camera IP: $_cameraIP'),
          ],
        )
            : Text(_statusMessage),
      ),
      floatingActionButton: _isConnected
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller != null) {
              _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
            }
          });
        },
        backgroundColor: Colors.green,
        child: Icon(
          _controller != null && _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      )
          : null,
    );
  }
}
