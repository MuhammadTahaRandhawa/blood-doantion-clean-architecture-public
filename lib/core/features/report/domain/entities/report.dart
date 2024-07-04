import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Report {
  final String reportId;
  final String userId, userName;

  final String text;
  final DateTime timestamp;
  final ReportType reportType;

  Report({
    String? reportId,
    required this.reportType,
    required this.userName,
    required this.userId,
    required this.text,
    required this.timestamp,
  }) : reportId = reportId ?? uuid.v4();
}

enum ReportType { donation, request, centre, chat }
