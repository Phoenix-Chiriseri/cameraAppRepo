class CameraService {
  final String ipAddress;
  CameraService(this.ipAddress);
  Future<String> getStreamUrl() async {
    // Assuming the camera's stream URL is at a fixed path
    const path = '/video.mp4';
    // Ensure the IP address includes the scheme
    String streamUrl = 'https://$ipAddress$path';
    return streamUrl;
  }
}