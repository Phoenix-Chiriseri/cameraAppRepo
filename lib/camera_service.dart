import 'package:http/http.dart' as http;

class CameraService {
  final String _baseUrl;

  CameraService(this._baseUrl);

  Future<String> getStreamUrl() async {
    try {
      // Example: Perform HTTP request to get the stream URL
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        // Assume the response body contains the stream URL
        return response.body;
      } else {
        throw Exception('Failed to load stream URL');
      }
    } catch (e) {
      print('Error getting stream URL: $e');
      rethrow;
    }
  }
}
