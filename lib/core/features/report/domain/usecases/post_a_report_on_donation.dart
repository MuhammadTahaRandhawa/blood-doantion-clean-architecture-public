import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/domain/repository/report_repository.dart';

import 'package:myapp/core/usecase/usecase.dart';

class PostAReportOnDonation implements Usecase<Unit, DonationReportParams> {
  final ReportRepository reportRepositpry;

  PostAReportOnDonation(this.reportRepositpry);
  @override
  Future<Either<Failure, Unit>> call(DonationReportParams params) async {
    return await reportRepositpry.postAReportOnDonation(
        params.report, params.donationId);
  }
}

class DonationReportParams {
  final Report report;
  final String donationId;

  DonationReportParams(this.report, this.donationId);
}
