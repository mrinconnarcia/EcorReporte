import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/info_model.dart';

class InfoRepositoryImpl {
  final String baseUrl = 'https://gjhmw1vf-3005.use.devtunnels.ms';

  InfoRepositoryImpl();

  Future<List<InfoModel>> getAllContent() async {
    final response = await http.get(Uri.parse('$baseUrl/educational-content/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => InfoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load content');
    }
  }

  Future<InfoModel> getContentById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/educational-content/$id'));

    if (response.statusCode == 200) {
      return InfoModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load content');
    }
  }

  Future<void> createContent(InfoModel content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/content'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(content.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create content');
    }
  }

  Future<void> updateContent(int id, InfoModel content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/educational-content/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(content.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update content');
    }
  }

  Future<void> deleteContent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/educational-content/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete content');
    }
  }
}
