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

  Future<Info?> getContentByCode(String code, String token) async {
    try {
      final response = await _dio.get(
        '$baseUrl/code/$code',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return Info.fromJson(data);
      } else {
        throw Exception('Failed to load content');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load content: ${e.message}');
      }
    }
  }

  // Future<List<Info>> getAllContentByCode(String code, String token) async {
  //   final response = await _dio.get(
  //     '$baseUrl/code/$code/all',
  //     options: Options(
  //       headers: {'Authorization': 'Bearer $token'},
  //     ),
  //   );

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonList = response.data;
  //     return jsonList.map((json) => Info.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load content: ${response.statusMessage}');
  //   }
  // }

  Future<void> updateContent(
      int id, Map<String, dynamic> updateData, String token) async {
    try {
      final response = await _dio.put(
        '$baseUrl/$id',
        data: jsonEncode(updateData), // Convertimos los datos a JSON
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Content updated successfully');
      } else {
        throw Exception('Failed to update content: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error updating content: $e');
      throw Exception('Error updating content: $e');
    }
  }

  Future<void> deleteContent(int id, String token) async {
    final response = await _dio.delete(
      '$baseUrl/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete content: ${response.statusMessage}');
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
