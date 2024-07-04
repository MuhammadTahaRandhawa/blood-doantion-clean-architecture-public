import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/domain/repository/report_repository.dart';

import 'package:myapp/core/usecase/usecase.dart';

class PostAReportOnRequest implements Usecase<Unit, RequestReportParams> {
  final ReportRepository reportRepositpry;

  PostAReportOnRequest(this.reportRepositpry);
  @override
  Future<Either<Failure, Unit>> call(RequestReportParams params) async {
    return await reportRepositpry.postAReportOnRequest(
        params.report, params.requestId);
  }
}

class RequestReportParams {
  final Report report;
  final String requestId;

  RequestReportParams(this.report, this.requestId);
}
