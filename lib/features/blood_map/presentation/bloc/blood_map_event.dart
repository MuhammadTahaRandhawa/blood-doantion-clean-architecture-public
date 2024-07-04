part of 'blood_map_bloc.dart';

@immutable
sealed class BloodMapEvent {}

class BloodMapAllMarkersAroundUserFetched extends BloodMapEvent {
  final LatitudeLongitude latitudeLongitude;
  final User currentUser;
  final List<String> bloodGroups;
  final int radius;
  BloodMapAllMarkersAroundUserFetched(
      {required this.latitudeLongitude,
      required this.bloodGroups,
      required this.radius,
      required this.currentUser});
}

class BloodMapRequestsMarkersAroundUserFetched extends BloodMapEvent {
  final LatitudeLongitude latitudeLongitude;
  final List<String> bloodGroups;
  final int radius;
  final User currentUser;
  BloodMapRequestsMarkersAroundUserFetched(
      {required this.latitudeLongitude,
      required this.bloodGroups,
      required this.radius,
      required this.currentUser});
}

class BloodMapDonationsMarkersAroundUserFetched extends BloodMapEvent {
  final LatitudeLongitude latitudeLongitude;
  final List<String> bloodGroups;
  final int radius;
  final User currentUser;
  BloodMapDonationsMarkersAroundUserFetched(
      {required this.latitudeLongitude,
      required this.bloodGroups,
      required this.radius,
      required this.currentUser});
}

class BloodMapCentersMarkersAroundUserFetched extends BloodMapEvent {
  final LatitudeLongitude latitudeLongitude;
  final List<String> bloodGroups;
  final int radius;
  final User currentUser;
  BloodMapCentersMarkersAroundUserFetched(
      {required this.latitudeLongitude,
      required this.bloodGroups,
      required this.radius,
      required this.currentUser});
}
