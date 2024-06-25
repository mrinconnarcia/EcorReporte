import 'package:ecoreporte/data/models/report_model.dart';
import 'package:http/http.dart' as http;

abstract class ReportRemoteDataSource {
  Future<void> createReport(ReportModel report);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final http.Client client;

  ReportRemoteDataSourceImpl({required this.client});

  @override
  Future<void> createReport(ReportModel report) async {
    final response = await client.post(
      Uri.parse('https://example.com/reports'),
      body: report.toJson(),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create report');
    }
  }
}
