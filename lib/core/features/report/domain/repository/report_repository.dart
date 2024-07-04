import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';

abstract interface class ReportRepository {
  Future<Either<Failure, Unit>> postAReportOnDonation(
      Report report, String donationId);
  Future<Either<Failure, List<Report>>> fetchDonationReports(String donationId);
  Future<Either<Failure, Unit>> postAReportOnRequest(
      Report report, String requestId);
  Future<Either<Failure, List<Report>>> fetchRequestReports(String requestId);
  Future<Either<Failure, Unit>> postAReportOnChat(Report report, String chatId);
  Future<Either<Failure, List<Report>>> fetchChatReports(String chatId);
}
