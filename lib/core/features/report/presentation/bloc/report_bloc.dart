import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/domain/usecases/fetch_reports_on_donation.dart';
import 'package:myapp/core/features/report/domain/usecases/fetch_reports_on_request.dart';
import 'package:myapp/core/features/report/domain/usecases/post_a_report_on_donation.dart';
import 'package:myapp/core/features/report/domain/usecases/post_a_report_on_request.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final FetchReportsOnDonation fetchReportsOnDonation;
  final PostAReportOnDonation postAReportOnDonation;
  final PostAReportOnRequest postAReportOnRequest;
  final FetchReportsOnRequest fetchReportsOnRequest;
  ReportBloc(this.fetchReportsOnDonation, this.postAReportOnDonation,
      this.postAReportOnRequest, this.fetchReportsOnRequest)
      : super(ReportInitial()) {
    //post Report on donation
    on<ReportOnDonationPosted>((event, emit) async {
      emit(ReportPostLoading());
      final res = await postAReportOnDonation
          .call(DonationReportParams(event.report, event.donationId));
      res.fold((l) => emit(PostAReportFailure(l.message)),
          (r) => emit(PostAReportSuccess()));
    });

    //Post a Report on Request
    on<ReportOnRequestPosted>((event, emit) async {
      emit(ReportPostLoading());
      final res = await postAReportOnRequest
          .call(RequestReportParams(event.report, event.requestId));
      res.fold((l) => emit(PostAReportFailure(l.message)),
          (r) => emit(PostAReportSuccess()));
    });

    //Fetch Donation Reports
    on<ReportOnDonationFetched>((event, emit) async {
      emit(ReportPostLoading());
      final res = await fetchReportsOnDonation.call(event.donationId);
      res.fold((l) => emit(FetchReportFailure(l.message)),
          (r) => emit(FetchReportSuccess(r)));
    });

    //Fetch Request Reports
    on<ReportOnRequestFetched>((event, emit) async {
      emit(ReportPostLoading());
      final res = await fetchReportsOnRequest.call(event.requestId);
      res.fold((l) => emit(FetchReportFailure(l.message)),
          (r) => emit(FetchReportSuccess(r)));
    });
  }
}
