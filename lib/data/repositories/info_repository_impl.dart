import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/info.dart';

class InfoRepositoryImpl {
  final String baseUrl = 'http://54.225.155.228:3001/api/education/educational';

  InfoRepositoryImpl();

  Future<List<Info>> getAllContent(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/all'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Info.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load content: ${response.reasonPhrase}');
    }
  }

  Future<Info> getContentById(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/educational-content/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Info.fromJson(json.decode(response.body));
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

  Future<void> updateContent(int id, Info content, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/educational-content/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(content.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update content: ${response.reasonPhrase}');
    }
  }

  Future<void> deleteContent(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/educational-content/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete content: ${response.reasonPhrase}');
    }
  }
}
