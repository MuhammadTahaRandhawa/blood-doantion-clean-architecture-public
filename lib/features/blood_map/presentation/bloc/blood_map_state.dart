part of 'blood_map_bloc.dart';

@immutable
sealed class BloodMapState {}

final class BloodMapInitial extends BloodMapState {}

final class BloodMapAllMarkersFetchFailure extends BloodMapState {
  final String message;

  BloodMapAllMarkersFetchFailure(this.message);
}

final class BloodMapAllMarkersFetchSuccess extends BloodMapState {
  final List<MapMarker> markers;

  BloodMapAllMarkersFetchSuccess(this.markers);
}

final class BloodMapMarkersFetchLoading extends BloodMapState {}

final class BloodMapRequestsMarkersFetchFailure extends BloodMapState {
  final String message;

  BloodMapRequestsMarkersFetchFailure(this.message);
}

final class BloodMapRequestsMarkersFetchSuccess extends BloodMapState {
  final List<MapMarker> markers;

  BloodMapRequestsMarkersFetchSuccess(this.markers);
}

final class BloodMapDonationsMarkersFetchFailure extends BloodMapState {
  final String message;

  BloodMapDonationsMarkersFetchFailure(this.message);
}

final class BloodMapDonationsMarkersFetchSuccess extends BloodMapState {
  final List<MapMarker> markers;

  BloodMapDonationsMarkersFetchSuccess(this.markers);
}

final class BloodMapCentersMarkersFetchFailure extends BloodMapState {
  final String message;

  BloodMapCentersMarkersFetchFailure(this.message);
}

final class BloodMapCentersMarkersFetchSuccess extends BloodMapState {
  final List<MapMarker> markers;

  BloodMapCentersMarkersFetchSuccess(this.markers);
}
