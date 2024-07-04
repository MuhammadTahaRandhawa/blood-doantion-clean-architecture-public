part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

class LocationPermissionRequested extends LocationEvent {}

class LocationPositionFetched extends LocationEvent {}

class LocationAddressFetched extends LocationEvent {
  final LatitudeLongitude latitudeLongitude;

  LocationAddressFetched(this.latitudeLongitude);
}

class LocationFetched extends LocationEvent {}
