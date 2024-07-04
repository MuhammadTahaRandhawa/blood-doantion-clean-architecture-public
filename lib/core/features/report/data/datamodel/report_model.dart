import 'package:myapp/core/features/report/domain/entities/report.dart';

class ReportModel extends Report {
  ReportModel(
      {required super.reportId,
      required super.reportType,
      required super.userId,
      required super.text,
      required super.timestamp,
      required super.userName});

  factory ReportModel.fromReport(Report report) {
    return ReportModel(
        reportId: report.reportId,
        userName: report.userName,
        reportType: report.reportType,
        userId: report.userId,
        text: report.text,
        timestamp: report.timestamp);
  }

  factory ReportModel.fromJson(
      Map<String, dynamic> map, ReportType reportType) {
    return ReportModel(
        reportId: map['reportId'],
        userName: map['userName'],
        reportType: reportType,
        userId: map['userId'],
        text: map['text'],
        timestamp: map['timestamp'].toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'userId': userId,
      'text': text,
      'timestamp': timestamp,
      'userName': userName
    };
  }

  // // Function to convert reportType enum to string
  // String getReportTypeAsString(CommentType commentType) {
  //   switch (commentType) {
  //     case CommentType.donation:
  //       return 'donation';
  //     case CommentType.request:
  //       return 'request';
  //     case CommentType.centre:
  //       return 'centre';
  //     default:
  //       throw ArgumentError('Invalid enum value');
  //   }
  // }

  // // Function to convert string to CommentType enum
  // static CommentType getCommentTypeFromString(String commentType) {
  //   switch (commentType) {
  //     case 'donation':
  //       return CommentType.donation;
  //     case 'request':
  //       return CommentType.request;
  //     case 'centre':
  //       return CommentType.centre;
  //     default:
  //       throw ArgumentError('Invalid string value');
  //   }
  // }
}
