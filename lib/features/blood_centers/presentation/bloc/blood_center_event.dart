part of 'blood_center_bloc.dart';

@immutable
sealed class BloodCenterEvent {}

class BloodCentersAroundUserFetched extends BloodCenterEvent {
  final LatitudeLongitude latitudeLongitude;

  BloodCentersAroundUserFetched(this.latitudeLongitude);
}

class BloodCenterByIdFetched extends BloodCenterEvent {
  final String id;

  BloodCenterByIdFetched(this.id);
}
