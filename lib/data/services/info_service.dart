import 'dart:convert';
import 'package:http/http.dart' as http;

class InfoService {
  final String apiUrl = 'https://tu-api.com/info';

  Future<Map<String, dynamic>> fetchInfo() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load info');
    }
  }
}
