part of 'location_bloc.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationSuccess extends LocationState {
  final dynamic successData;

  LocationSuccess(this.successData);
}

final class LocationFailure extends LocationState {
  final String message;
  LocationFailure(this.message);
}

final class LocationPermissionFailure extends LocationState {
  final String message;
  LocationPermissionFailure(this.message);
}

final class LocationPermissionSuccess extends LocationState {}
