import 'dart:io';
import 'package:ecoreporte/domain/entities/report.dart';
import 'package:ecoreporte/domain/entities/report_summary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/secure_storage.dart';

class ReportRepositoryImpl {
  final String initialApiUrl = "http://54.225.155.228:3001/api/reporting/reports";
  final SecureStorage secureStorage = SecureStorage(); // Añadir esto para acceder al token

  Future<void> createReport(Map<String, dynamic> reportData, String filePath) async {
  Uri uri = Uri.parse(initialApiUrl);
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

  // Get the authentication token
  String? token = await secureStorage.getToken();
  if (token == null) {
    throw Exception('Token not found');
  }

  // Add headers
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Content-Type'] = 'multipart/form-data';

  try {
    var response = await request.send();
    var client = http.Client();

    // Handle redirects
    while (response.isRedirect) {
      final redirectUrl = response.headers['location'];
      if (redirectUrl == null) {
        throw Exception('Failed to get redirect URL');
      }
      uri = Uri.parse(redirectUrl);
      request = http.MultipartRequest('POST', uri)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files)
        ..headers.addAll(request.headers);
      response = await client.send(request);
    }

    var responseBody = await response.stream.bytesToString();
    print('Final URL: $uri');
    print('Response status: ${response.statusCode}');
    print('Response body: $responseBody');

    if (response.statusCode == 200 || response.statusCode == 201) {
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
    final response = await http.get(Uri.parse('$initialApiUrl/pdf-list'), headers: {
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
      Uri.parse('$initialApiUrl/${report.id}'),
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
    final response = await http.delete(Uri.parse('$initialApiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el reporte');
    }
  }
}
