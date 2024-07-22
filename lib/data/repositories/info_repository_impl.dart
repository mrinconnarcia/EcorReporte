import 'dart:convert';

import 'package:dio/dio.dart';
import '../../domain/entities/info.dart';

class InfoRepositoryImpl {
  final String baseUrl = 'http://54.225.155.228:3001/api/education/educational';
  final Dio _dio = Dio();

  Future<List<Info>> getAllContent(String token) async {
    final response = await _dio.get(
      '$baseUrl/all',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Info.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load content: ${response.statusMessage}');
    }
  }

  Future<void> createContent(FormData formData, String token) async {
    final response = await _dio.post(
      '$baseUrl/create',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create content: ${response.statusMessage}');
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
