import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/report/data/datamodel/report_model.dart';
import 'package:myapp/core/features/report/data/datasources/reports_remote_data_source.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/domain/repository/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportsRemoteDataSource reportRemoteDataSource;

  ReportRepositoryImpl(this.reportRemoteDataSource);
  @override
  Future<Either<Failure, List<Report>>> fetchDonationReports(
      String donationId) async {
    try {
      final res = await reportRemoteDataSource.fetchDonationReports(donationId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Report>>> fetchRequestReports(
      String requestId) async {
    try {
      final res = await reportRemoteDataSource.fetchRequestReports(requestId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> postAReportOnDonation(
      Report report, String donationId) async {
    try {
      final res = await reportRemoteDataSource.postAReportOnDonation(
          ReportModel.fromReport(report), donationId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> postAReportOnRequest(
      Report report, String requestId) async {
    try {
      final res = await reportRemoteDataSource.postAReportOnRequest(
          ReportModel.fromReport(report), requestId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Report>>> fetchChatReports(String chatId) {
    // TODO: implement fetchChatReports
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> postAReportOnChat(
      Report report, String chatId) {
    // TODO: implement postAReportOnChat
    throw UnimplementedError();
  }
}
