part of 'report_bloc.dart';

@immutable
sealed class ReportEvent {}

class ReportOnDonationFetched extends ReportEvent {
  final String donationId;

  ReportOnDonationFetched(this.donationId);
}

class ReportOnRequestFetched extends ReportEvent {
  final String requestId;

  ReportOnRequestFetched(this.requestId);
}

class ReportOnDonationPosted extends ReportEvent {
  final String donationId;
  final Report report;
  ReportOnDonationPosted(this.donationId, this.report);
}

class ReportOnRequestPosted extends ReportEvent {
  final String requestId;
  final Report report;

  ReportOnRequestPosted(this.requestId, this.report);
}
