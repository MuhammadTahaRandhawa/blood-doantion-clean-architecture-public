part of 'blood_request_bloc.dart';

@immutable
sealed class BloodRequestEvent {}

class BloodRequestsFetched extends BloodRequestEvent {}

class BloodRequestPosted extends BloodRequestEvent {
  final Request request;
  BloodRequestPosted({required this.request});
}

class BloodRequestsStreamFetched extends BloodRequestEvent {
  final LatitudeLongitude latitudeLongitude;

  BloodRequestsStreamFetched(this.latitudeLongitude);
}

class MyBloodRequestsFetched extends BloodRequestEvent {}

class BloodRequestStreamSubscriptionCancled extends BloodRequestEvent {}

class BloodRequestInsideARadiusFetched extends BloodRequestEvent {
  final LatitudeLongitude latitudeLongitude;

  BloodRequestInsideARadiusFetched(this.latitudeLongitude);
}

class BloodRequestByIdFetched extends BloodRequestEvent {
  final String id;

  BloodRequestByIdFetched(this.id);
}
