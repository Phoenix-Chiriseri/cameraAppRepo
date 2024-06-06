import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'camera_service.dart';

class CameraExample2 extends StatefulWidget {
  @override
  _CameraExample2State createState() => _CameraExample2State();
}
class _CameraExample2State extends State<CameraExample2> {
  VideoPlayerController? _controller; // Use nullable VideoPlayerController
  late Future<void> _initializeVideoPlayerFuture;
  final CameraService _cameraService = CameraService('https://192.168.1.100'); // Replace with your camera's IP address
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      String streamUrl = await _cameraService.getStreamUrl();
      _controller = VideoPlayerController.networkUrl(streamUrl as Uri);
      _initializeVideoPlayerFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing video player: $e');
      // Handle error gracefully, e.g., show error message
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose if not null
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('External Camera Stream'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: _controller != null
            ? FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller != null) {
              _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
            }
          });
        },
        child: Icon(
          _controller != null && _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
