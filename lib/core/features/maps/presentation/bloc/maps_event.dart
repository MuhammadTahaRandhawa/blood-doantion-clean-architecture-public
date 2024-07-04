part of 'maps_bloc.dart';

@immutable
sealed class MapsEvent {}

class MapsStaticImageFetched extends MapsEvent {
  final LatitudeLongitude latitudeLongitude;
  MapsStaticImageFetched(this.latitudeLongitude);
}
