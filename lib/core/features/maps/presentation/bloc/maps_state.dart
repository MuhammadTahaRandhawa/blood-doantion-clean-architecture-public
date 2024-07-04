part of 'maps_bloc.dart';

@immutable
sealed class MapsState {}

final class MapsInitial extends MapsState {}

final class MapsStaticImageLoading extends MapsState {}

final class MapsStaticImageSuccess extends MapsState {
  final Image image;

  MapsStaticImageSuccess(this.image);
}

final class MapsStaticImageFailure extends MapsState {
  final String message;

  MapsStaticImageFailure(this.message);
}
