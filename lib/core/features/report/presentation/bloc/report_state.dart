part of 'report_bloc.dart';

@immutable
sealed class ReportState {}

final class ReportInitial extends ReportState {}

final class ReportFetchLoading extends ReportState {}

final class ReportPostLoading extends ReportState {}

final class PostAReportFailure extends ReportState {
  final String message;

  PostAReportFailure(this.message);
}

final class PostAReportSuccess extends ReportState {}

final class FetchReportSuccess extends ReportState {
  final List<Report> report;

  FetchReportSuccess(this.report);
}

final class FetchReportFailure extends ReportState {
  final String message;

  FetchReportFailure(this.message);
}
