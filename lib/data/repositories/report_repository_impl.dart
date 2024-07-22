import 'dart:io';
import 'package:ecoreporte/domain/entities/report_summary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/report.dart';

class ReportRepositoryImpl {
  final String apiUrl = "http://54.225.155.228:3001/api/reporting/reports";

  Future<void> createReport(
      Map<String, dynamic> reportData, String filePath) async {
    var uri = Uri.parse(apiUrl);
    var request = http.MultipartRequest('POST', uri);

    // Add form fields
    request.fields['titulo_reporte'] = reportData['TITLE'];
    request.fields['tipo_reporte'] = reportData['TYPE'];
    request.fields['descripcion'] = reportData['DESCRIPTION'];
    request.fields['colonia'] = reportData['PLACE'];
    request.fields['codigo_postal'] = reportData['POSTAL_CODE'];
    request.fields['nombres'] = reportData['NAMES'];
    request.fields['apellidos'] = reportData['LASTNAME'];
    request.fields['telefono'] = reportData['PHONE'];
    request.fields['correo'] = reportData['EMAIL'];

    // Add the image file
    request.files.add(await http.MultipartFile.fromPath('image', filePath));

    // Print request details for debugging
    print('Initial Request URL: ${request.url}');
    print('Request fields: ${request.fields}');
    print('Request files: ${request.files}');

    try {
      var client = http.Client();
      var response = await client.send(request);

      // Handle redirects manually if needed
      while (response.isRedirect) {
        print('Redirecting to: ${response.headers['location']}');
        uri = uri.resolve(response.headers['location']!);
        request = http.MultipartRequest('POST', uri)
          ..fields.addAll(request.fields)
          ..files.addAll(request.files);
        response = await client.send(request);
      }

      var responseBody = await response.stream.bytesToString();
      print('Final URL: $uri');
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        print('Report created successfully');
      } else {
        throw Exception('Failed to create report: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating report: $e');
      throw Exception('Error creating report: $e');
    }
  }

  Future<List<ReportSummary>> fetchReports(String token) async {
    final response = await http.get(Uri.parse('$apiUrl/pdf-list'), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((report) => ReportSummary.fromJson(report)).toList();
    } else {
      throw Exception('Error al cargar los reportes');
    }
  }

  Future<void> updateReport(Report report) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${report.id}'),
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
