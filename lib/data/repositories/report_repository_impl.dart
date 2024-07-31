import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecoreporte/domain/entities/report.dart';
import 'package:ecoreporte/domain/entities/report_summary.dart';

class ReportRepositoryImpl {
  // final String initialApiUrl =
  //     "http://54.225.155.228:3001/api/reporting/reports";
  final String initialApiUrl =
      "https://reporting-service-3.onrender.com/reports";

  final Dio _dio = Dio();

  Future<void> createReport(
      Report report, String filePath, String token) async {
    try {
      final formData = FormData.fromMap({
        ...report.toJson(),
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
      print('Dio error!');
      if (e.response != null) {
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
      throw Exception('Failed to create report: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred: $e');
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
    try {
      final response = await _dio.get(
        '$initialApiUrl/pdf-list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Check if the response data is a String
        if (response.data is String) {
          // If it's a String, try to parse it as JSON
          List<dynamic> jsonData = json.decode(response.data);
          return jsonData
              .map((report) => ReportSummary.fromJson(report))
              .toList();
        }
        // If it's already a List, use it directly
        else if (response.data is List) {
          List<dynamic> data = response.data;
          return data.map((report) => ReportSummary.fromJson(report)).toList();
        }
        // If it's neither a String nor a List, throw an error
        else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Error al cargar los reportes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reports: $e');
      throw Exception('Failed to fetch reports: $e');
    }
  }

  Future<void> updateReportStatus(
      String id, String status, String token) async {
    try {
      final response = await _dio.patch(
        '$initialApiUrl/$id/status',
        data: {'estatus': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar el estado del reporte');
      }
    } catch (e) {
      print('Error updating report status: $e');
      throw Exception('Failed to update report status: $e');
    }
  }

  Future<void> deleteReport(String id, String token,
      {required String tituloReporte}) async {
    try {
      // First, show a confirmation dialog (this should be done in the UI layer)
      // For demonstration, we'll just print the confirmation message
      print(
          '¿Estás seguro de que deseas eliminar el reporte "$tituloReporte"?');

      final response = await _dio.delete(
        '$initialApiUrl/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Reporte eliminado exitosamente');
      } else {
        throw DioError(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Unexpected status code: ${response.statusCode}',
        );
      }
    } on DioError catch (e) {
      print('Dio error!');
      if (e.response != null) {
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
      throw Exception('Failed to delete report: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception(
          'An unexpected error occurred while deleting the report: $e');
    }
  }
}
