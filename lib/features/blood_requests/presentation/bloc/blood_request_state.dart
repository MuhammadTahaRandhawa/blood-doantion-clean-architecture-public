part of 'blood_request_bloc.dart';

@immutable
sealed class BloodRequestState {}

final class BloodRequestInitial extends BloodRequestState {}

final class BloodRequestsFetchFailure extends BloodRequestState {
  final String message;

  BloodRequestsFetchFailure(this.message);
}

final class BloodRequestsFetchSuccess extends BloodRequestState {
  final List<Request> requests;

  BloodRequestsFetchSuccess(this.requests);
}

final class BloodRequestPostLoading extends BloodRequestState {}

final class BloodRequestsAllFetchLoading extends BloodRequestState {}

final class MyBloodRequestFetchLoading extends BloodRequestState {}

final class BloodRequestInsideRadiusFetchLoading extends BloodRequestState {}

final class BloodRequestPostFailure extends BloodRequestState {
  final String message;

  BloodRequestPostFailure(this.message);
}

final class BloodRequestPostSuccess extends BloodRequestState {}

final class BloodRequestStreamSuccess extends BloodRequestState {
  final Stream<List<Request>> streamOfRequests;

  BloodRequestStreamSuccess(this.streamOfRequests);
}

final class BloodRequestStreamFailure extends BloodRequestState {
  final String message;

  BloodRequestStreamFailure(this.message);
}

final class MyBloodRequestsFetchedFailure extends BloodRequestState {
  final String message;

  MyBloodRequestsFetchedFailure(this.message);
}

final class MyBloodRequestFetchedSuccess extends BloodRequestState {
  final List<Request> myRequests;

  MyBloodRequestFetchedSuccess(this.myRequests);
}

final class BloodRequestInsideARadiusFetchedSuccess extends BloodRequestState {
  final List<Request> bloodRequests;

  BloodRequestInsideARadiusFetchedSuccess(this.bloodRequests);
}

final class BloodRequestInsideARadiusFetchedFailure extends BloodRequestState {
  final String message;

  BloodRequestInsideARadiusFetchedFailure(this.message);
}

final class BloodRequestByIdFetchedSuccess extends BloodRequestState {
  final Request request;

  BloodRequestByIdFetchedSuccess(this.request);
}

final class BloodRequestByIdFetchedFailure extends BloodRequestState {
  final String message;

  BloodRequestByIdFetchedFailure(this.message);
}
