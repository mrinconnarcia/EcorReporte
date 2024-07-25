import 'package:http/http.dart' as http;
import 'dart:typed_data';
import '../../utils/secure_storage.dart';

class StatisticsReportRepositoryImpl {
  final String baseUrl = 'https://t2zd2jpn-3003.usw3.devtunnels.ms';
  final SecureStorage secureStorage = SecureStorage();

  Future<Uint8List> getPieChartImage() async {
    return _getChartImage('$baseUrl/statistics/pie-chart');
  }

  Future<Uint8List> getBarChartImage() async {
    return _getChartImage('$baseUrl/statistics/bar-chart');
  }

  Future<Uint8List> _getChartImage(String url) async {
    final token = await secureStorage.getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('First 100 bytes of response: ${response.bodyBytes.take(100)}');

    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('image/') == true) {
        return response.bodyBytes;
      } else {
        throw Exception('Invalid content type: ${response.headers['content-type']}');
      }
    } else {
      throw Exception('Failed to load chart image. Status code: ${response.statusCode}');
    }
  }
}