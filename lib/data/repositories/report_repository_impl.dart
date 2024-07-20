import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/report.dart';

class ReportRepositoryImpl {
  final String apiUrl =
      "https://t2zd2jpn-5000.usw3.devtunnels.ms/reports";

  Future<void> createReport(
      Map<String, dynamic> reportData, String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields.addAll(
        reportData.map((key, value) => MapEntry(key, value.toString())));
    request.files.add(await http.MultipartFile.fromPath('image', filePath));

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Error al crear el reporte');
    }
  }

  Future<List<Report>> fetchReports(String token) async {
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((report) => Report.fromJson(report)).toList();
    } else {
      throw Exception('Error al cargar los reportes');
    }
  }

  Future<void> updateReport(Report report) async {
    final response = await http.put(
      Uri.parse('$apiUrl/reports/${report.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(report.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el reporte');
    }
  }

  Future<void> deleteReport(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el reporte');
    }
  }
}
