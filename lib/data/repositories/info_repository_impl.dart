import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/info.dart';

class InfoRepositoryImpl {
  final String baseUrl = 'http://54.225.155.228:3001/api/education/educational';

  Future<List<Info>> getAllContent(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/all'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Info.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load content: ${response.reasonPhrase}');
    }
  }

  Future<void> createContent(Info content, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(content.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create content: ${response.reasonPhrase}');
    }
  }

  Future<String> getRoleFromToken(String token) async {
    final payload = _decodeToken(token);
    if (payload['role'] != null) {
      return payload['role'];
    } else {
      throw Exception('Role not found in token');
    }
  }

  Map<String, dynamic> _decodeToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = json.decode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    return payload;
  }
}