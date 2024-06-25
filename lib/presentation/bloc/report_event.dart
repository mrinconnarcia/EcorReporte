part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateReportEvent extends ReportEvent {
  final Report report;

  CreateReportEvent({required this.report});

  @override
  List<Object> get props => [report];
}
