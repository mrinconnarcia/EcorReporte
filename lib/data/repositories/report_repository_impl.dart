// import 'package:ecoreporte/core/network/network_info.dart';
// import 'package:ecoreporte/data/datasources/report_local_data_source.dart';
// import 'package:ecoreporte/data/datasources/report_remote_data_source.dart';
// import 'package:ecoreporte/data/models/report_model.dart';
// import 'package:ecoreporte/domain/entities/report.dart';
// import 'package:ecoreporte/domain/repositories/report_repository.dart';

// class ReportRepositoryImpl implements ReportRepository {
//   final ReportRemoteDataSource remoteDataSource;
//   final ReportLocalDataSource localDataSource;
//   final NetworkInfo networkInfo;

//   ReportRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<void> createReport(Report report) async {
//     if (await networkInfo.isConnected) {
//       await remoteDataSource.createReport(report as ReportModel);
//     } else {
//       await localDataSource.cacheReport(report as ReportModel);
//     }
//   }

//   @override
//   Future<void> syncReports() async {
//     if (await networkInfo.isConnected) {
//       final reports = await localDataSource.getLastReports();
//       for (final report in reports) {
//         await remoteDataSource.createReport(report);
//       }
//       localDataSource.clearCachedReports();
//     }
//   }
// }
