import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/features/location/domain/usecases/get_current_address.dart';
import 'package:myapp/core/features/location/domain/usecases/get_current_location.dart';
import 'package:myapp/core/features/location/domain/usecases/get_current_position.dart';
import 'package:myapp/core/features/location/domain/usecases/get_location_permission.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentAddress _getCurrentAddress;
  final GetCurrentLocation _getCurrentLocation;
  final GetCurrentPosition _getCurrentPosition;
  final GetLocationPermission _getLocationPermission;
  LocationBloc(
      GetCurrentAddress getCurrentAddress,
      GetCurrentLocation getCurrentLocation,
      GetCurrentPosition getCurrentPosition,
      GetLocationPermission getLocationPermission)
      : _getCurrentAddress = getCurrentAddress,
        _getCurrentLocation = getCurrentLocation,
        _getCurrentPosition = getCurrentPosition,
        _getLocationPermission = getLocationPermission,
        super(LocationInitial()) {
    on<LocationPermissionRequested>(locationPermissionRequested);
    on<LocationAddressFetched>(locationAddressFetched);
    on<LocationPositionFetched>(locationPositionFetched);
    on<LocationFetched>(currentLocationFetched);
  }

  locationPermissionRequested(
      LocationPermissionRequested event, Emitter emit) async {
    emit(LocationLoading());
    final response = await _getLocationPermission.call(Unit);
    response.fold((failure) => LocationPermissionFailure(failure.message),
        (r) => emit(LocationPermissionSuccess()));
  }

  locationAddressFetched(LocationAddressFetched event, Emitter emit) async {
    emit(LocationLoading());
    final response = await _getCurrentAddress.call(event.latitudeLongitude);
    response.fold((failure) => emit(LocationFailure(failure.message)),
        (address) => emit(LocationSuccess(address)));
  }

  locationPositionFetched(LocationPositionFetched event, Emitter emit) async {
    emit(LocationLoading());
    final response = await _getCurrentPosition.call(unit);
    response.fold((l) => emit(LocationFailure(l.message)),
        (r) => emit(LocationSuccess(r)));
  }

  currentLocationFetched(LocationFetched event, Emitter emit) async {
    emit(LocationLoading());
    final response = await _getCurrentLocation.call(unit);
    response.fold((l) => emit(LocationFailure(l.message)),
        (r) => emit(LocationSuccess(r)));
  }

  @override
  void onTransition(Transition<LocationEvent, LocationState> transition) {
    super.onTransition(transition);
    if (kDebugMode) {
      print(transition);
    }
  }
}
