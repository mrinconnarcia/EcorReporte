import 'package:dartz/dartz.dart';
import 'package:ecoreporte/core/error/failure.dart';
import 'package:ecoreporte/core/usecases/usecase.dart';
import 'package:ecoreporte/domain/entities/report.dart';
import 'package:ecoreporte/domain/repositories/report_repository.dart';

class CreateReport extends UseCase<void, Report> {
  final ReportRepository repository;

  CreateReport(this.repository);

  @override
  Future<Either<Failure, void>> call(Report report) async {
    return await repository.createReport(report);
  }
}
