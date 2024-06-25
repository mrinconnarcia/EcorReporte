part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportCreated extends ReportState {}

class ReportError extends ReportState {
  final String message;

  ReportError({required this.message});

  @override
  List<Object> get props => [message];
}
