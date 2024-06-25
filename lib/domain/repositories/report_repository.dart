import 'package:ecoreporte/domain/entities/report.dart';

abstract class ReportRepository {
  Future<void> createReport(Report report);
  Future<void> syncReports();
}
