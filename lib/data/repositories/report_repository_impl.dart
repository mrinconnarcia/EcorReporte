import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ecoreporte/domain/entities/report.dart';
import 'package:ecoreporte/domain/entities/report_summary.dart';
import '../../utils/secure_storage.dart';

class ReportRepositoryImpl {
  // final String initialApiUrl = "http://54.225.155.228:3001/api/reporting/reports";
  final String initialApiUrl =
      "https://t2zd2jpn-3003.usw3.devtunnels.ms/reports";

  final Dio _dio = Dio();

  Future<void> createReport(
      Map<String, String> reportData, String filePath, String token) async {
    try {
      final formData = FormData.fromMap({
        ...reportData,
        'image': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        '$initialApiUrl/',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Report created successfully');
      } else {
        throw DioError(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Unexpected status code: ${response.statusCode}',
        );
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
      throw Exception('Failed to create report: ${e.message}');
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

  Future<List<ReportSummary>> fetchReports(String token) async {
    final response = await _dio.get(
      '$initialApiUrl/pdf-list',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((report) => ReportSummary.fromJson(report)).toList();
    } else {
      throw Exception('Error al cargar los reportes');
    }
  }

  Future<void> updateReport(Report report) async {
    final response = await _dio.put(
      '$initialApiUrl/${report.id}',
      data: report.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el reporte');
    }
  }

  Future<void> deleteReport(int id) async {
    final response = await _dio.delete('$initialApiUrl/$id');

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el reporte');
    }
  }
}
