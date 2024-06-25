import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecoreporte/data/models/report_model.dart';

abstract class ReportLocalDataSource {
  Future<void> cacheReport(ReportModel reportToCache);
  Future<List<ReportModel>> getLastReports();
}

const CACHED_REPORTS = 'CACHED_REPORTS';

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  final SharedPreferences sharedPreferences;

  ReportLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheReport(ReportModel reportToCache) {
    final reports = sharedPreferences.getStringList(CACHED_REPORTS) ?? [];
    reports.add(reportToCache.toJson());
    return sharedPreferences.setStringList(CACHED_REPORTS, reports);
  }

  @override
  Future<List<ReportModel>> getLastReports() {
    final jsonStringList = sharedPreferences.getStringList(CACHED_REPORTS);
    if (jsonStringList != null) {
      return Future.value(jsonStringList.map((jsonString) => ReportModel.fromJson(jsonString)).toList());
    } else {
      return Future.value([]);
    }
  }
}
