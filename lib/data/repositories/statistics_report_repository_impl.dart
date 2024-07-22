import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/secure_storage.dart';

class StatisticsReportRepositoryImpl {
  final String baseUrl = 'https://tu-api-url.com'; // Reemplaza con tu URL real
  final SecureStorage secureStorage = SecureStorage();

  Future<List<Map<String, dynamic>>> getPieChartStatistics() async {
    final token = await secureStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/pie-chart-statistics'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => {
        'label': item['label'] as String,
        'value': item['value'] as int,
      }).toList();
    } else {
      throw Exception('Failed to load pie chart statistics');
    }
  }

  Future<List<Map<String, dynamic>>> getBarChartStatistics() async {
    final token = await secureStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/bar-chart-statistics'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => {
        'label': item['label'] as int, // Suponiendo que los labels son índices enteros
        'value': item['value'] as int,
      }).toList();
    } else {
      throw Exception('Failed to load bar chart statistics');
    }
  }
}
