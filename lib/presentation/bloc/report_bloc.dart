import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ecoreporte/domain/entities/report.dart';
import 'package:ecoreporte/domain/usecases/create_report.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final CreateReport createReport;

  ReportBloc({required this.createReport}) : super(ReportInitial());

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is CreateReportEvent) {
      yield ReportLoading();
      final failureOrSuccess = await createReport(event.report);
      yield failureOrSuccess.fold(
        (failure) => ReportError(message: 'Error creating report'),
        (_) => ReportCreated(),
      );
    }
  }
}
