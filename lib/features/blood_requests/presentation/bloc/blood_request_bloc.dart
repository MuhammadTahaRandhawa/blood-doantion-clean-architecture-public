import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/domain/usecases/fetchRequests.dart';
import 'package:myapp/features/blood_requests/domain/usecases/fetch_my_requests.dart';
import 'package:myapp/features/blood_requests/domain/usecases/fetch_request_by_id.dart';
import 'package:myapp/features/blood_requests/domain/usecases/fetch_requests_in_certain_radius.dart';
import 'package:myapp/features/blood_requests/domain/usecases/post_a_new_request.dart';
import 'package:myapp/features/blood_requests/domain/usecases/streamof_requests_in_certain_radius.dart';

part 'blood_request_event.dart';
part 'blood_request_state.dart';

class BloodRequestBloc extends Bloc<BloodRequestEvent, BloodRequestState> {
  final FetchRequests fetchRequests;
  final PostANewBloodRequest postANewRequest;
  final StreamOfRequestsInCertainRadius streamOfRequestsInCertainRadius;
  final FetchMyRequests fetchMyRequests;
  final FetchBloodRequestsInCertainRadius fetchBloodRequestsInCertainRadius;
  late StreamSubscription requestsStreamSubscription;
  final FetchRequestById fetchRequestById;

  BloodRequestBloc(
      this.fetchRequests,
      this.postANewRequest,
      this.streamOfRequestsInCertainRadius,
      this.fetchMyRequests,
      this.fetchBloodRequestsInCertainRadius,
      this.fetchRequestById)
      : super(BloodRequestInitial()) {
    on<BloodRequestPosted>((event, emit) async {
      emit(BloodRequestPostLoading());
      final response = await postANewRequest.call(event.request);

      response.fold((l) => emit(BloodRequestPostFailure(l.message)),
          (r) => emit(BloodRequestPostSuccess()));
    });
    on<BloodRequestsFetched>((event, emit) async {
      emit(BloodRequestsAllFetchLoading());
      final response = await fetchRequests.call(unit);
      response.fold((l) => emit(BloodRequestsFetchFailure(l.message)),
          (r) => emit(BloodRequestsFetchSuccess(r)));
    });

    on<BloodRequestsStreamFetched>((event, emit) {
      final response =
          streamOfRequestsInCertainRadius.call(event.latitudeLongitude);
      response.fold((l) => emit(BloodRequestStreamFailure(l.message)), (r) {
        requestsStreamSubscription = r.listen(
          (event) {},
        );
        return emit(BloodRequestStreamSuccess(r));
      });
    });
    on<MyBloodRequestsFetched>((event, emit) async {
      emit(MyBloodRequestFetchLoading());
      final res = await fetchMyRequests.call(unit);
      res.fold((l) => emit(MyBloodRequestsFetchedFailure(l.message)),
          (r) => emit(MyBloodRequestFetchedSuccess(r)));
    });
    on<BloodRequestStreamSubscriptionCancled>((event, emit) {
      requestsStreamSubscription.cancel();
    });

    on<BloodRequestInsideARadiusFetched>((event, emit) async {
      emit(BloodRequestInsideRadiusFetchLoading());
      final res =
          await fetchBloodRequestsInCertainRadius.call(event.latitudeLongitude);
      res.fold((l) => emit(BloodRequestInsideARadiusFetchedFailure(l.message)),
          (r) => emit(BloodRequestInsideARadiusFetchedSuccess(r)));
    });

    on<BloodRequestByIdFetched>((event, emit) async {
      final res = await fetchRequestById.call(event.id);
      res.fold((l) => emit(BloodRequestByIdFetchedFailure(l.message)),
          (r) => emit(BloodRequestByIdFetchedSuccess(r)));
    });
  }
  @override
  void onTransition(
      Transition<BloodRequestEvent, BloodRequestState> transition) {
    // TODO: implement onTransition
    super.onTransition(transition);
    print(transition);
  }
}
