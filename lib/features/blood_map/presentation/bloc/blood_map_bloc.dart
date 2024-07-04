import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:myapp/features/blood_map/domain/usecases/fetch_centers_map_markers_around_user.dart';
import 'package:myapp/features/blood_map/domain/usecases/fetch_donations_map_markers_around_user.dart';
import 'package:myapp/features/blood_map/domain/usecases/fetch_requests_maps_markers_around_user.dart';

part 'blood_map_event.dart';
part 'blood_map_state.dart';

class BloodMapBloc extends Bloc<BloodMapEvent, BloodMapState> {
  final FetchDonationsMapsMarkersAroundUser fetchDonationsMapsMarkersAroundUser;
  final FetchRequestsMapsMarkersAroundUser fetchRequestsMapsMarkersAroundUser;
  final FetchCentersMapsMarkersAroundUser fetchCentersMapsMarkersAroundUser;
  BloodMapBloc(
      this.fetchDonationsMapsMarkersAroundUser,
      this.fetchRequestsMapsMarkersAroundUser,
      this.fetchCentersMapsMarkersAroundUser)
      : super(BloodMapInitial()) {
    on<BloodMapEvent>((event, emit) => emit(BloodMapMarkersFetchLoading()));
    on<BloodMapAllMarkersAroundUserFetched>((event, emit) async {
      final List<MapMarker> markers = [];

      //donation markers
      final donationResponse = await fetchDonationsMapsMarkersAroundUser
          .call(event.latitudeLongitude);
      donationResponse.fold(
          (l) => emit(BloodMapDonationsMarkersFetchFailure(l.message)), (r) {
        log('donationMarkers ' + r.toString());
        final donationMarkers = _filteredMarkers(
            user: event.currentUser,
            radius: event.radius,
            bloodGroups: event.bloodGroups,
            currentUserPoints: event.latitudeLongitude,
            fethchedMarkers: r);
        markers.addAll(donationMarkers);
        log('donationMarkers filtered' + donationMarkers.toString());
      });

      //request Markers
      final requestResponse = await fetchRequestsMapsMarkersAroundUser
          .call(event.latitudeLongitude);
      requestResponse.fold(
          (l) => emit(BloodMapRequestsMarkersFetchFailure(l.message)), (r) {
        final requestMarkers = _filteredMarkers(
            user: event.currentUser,
            radius: event.radius,
            bloodGroups: event.bloodGroups,
            currentUserPoints: event.latitudeLongitude,
            fethchedMarkers: r);
        markers.addAll(requestMarkers);
      });

      //center markers
      final centersResponse =
          await fetchCentersMapsMarkersAroundUser.call(event.latitudeLongitude);
      centersResponse.fold(
          (l) => emit(BloodMapCentersMarkersFetchFailure(l.message)), (r) {
        final centersMarkers = _filteredMarkers(
            user: event.currentUser,
            radius: event.radius,
            bloodGroups: event.bloodGroups,
            isCenter: true,
            currentUserPoints: event.latitudeLongitude,
            fethchedMarkers: r);
        markers.addAll(centersMarkers);
      });

      return emit(BloodMapAllMarkersFetchSuccess(markers));
    });

    //Only Donation Markers
    on<BloodMapDonationsMarkersAroundUserFetched>((event, emit) async {
      final response = await fetchDonationsMapsMarkersAroundUser
          .call(event.latitudeLongitude);
      response.fold(
          (l) => emit(BloodMapDonationsMarkersFetchFailure(l.message)), (r) {
        final markers = _filteredMarkers(
            user: event.currentUser,
            radius: event.radius,
            bloodGroups: event.bloodGroups,
            currentUserPoints: event.latitudeLongitude,
            fethchedMarkers: r);
        return emit(BloodMapDonationsMarkersFetchSuccess(markers));
      });
    });

    on<BloodMapCentersMarkersAroundUserFetched>((event, emit) async {
      final response =
          await fetchCentersMapsMarkersAroundUser.call(event.latitudeLongitude);
      response.fold((l) => emit(BloodMapCentersMarkersFetchFailure(l.message)),
          (r) {
        final markers = _filteredMarkers(
            user: event.currentUser,
            radius: event.radius,
            bloodGroups: event.bloodGroups,
            currentUserPoints: event.latitudeLongitude,
            isCenter: true,
            fethchedMarkers: r);
        return emit(BloodMapCentersMarkersFetchSuccess(markers));
      });
    });

    //Only Requests Markers
    on<BloodMapRequestsMarkersAroundUserFetched>((event, emit) async {
      final response = await fetchRequestsMapsMarkersAroundUser
          .call(event.latitudeLongitude);
      response.fold((l) => emit(BloodMapRequestsMarkersFetchFailure(l.message)),
          (r) {
        final markers = _filteredMarkers(
            user: event.currentUser,
            radius: event.radius,
            bloodGroups: event.bloodGroups,
            currentUserPoints: event.latitudeLongitude,
            fethchedMarkers: r);

        return emit(BloodMapRequestsMarkersFetchSuccess(markers));
      });
    });
  }

  List<MapMarker> _filteredMarkers(
      {required int radius,
      required List<String> bloodGroups,
      required User user,
      required LatitudeLongitude currentUserPoints,
      required List<MapMarker> fethchedMarkers,
      bool isCenter = false}) {
    final List<MapMarker> markers = [];
    for (MapMarker marker in fethchedMarkers) {
      final distance = (Geolocator.distanceBetween(
          currentUserPoints.latitude,
          currentUserPoints.longitude,
          marker.location.latitude,
          marker.location.longitude));
      if (!isCenter) {
        if (radius * 1000 > distance &&
            bloodGroups.contains(marker.bloodGroup)) {
          if (marker.userId == user.userId &&
              marker.mapMarkerType == MapMarkerType.donation) {
          } else {
            markers.add(marker);
          }
        }
      } else {
        if (radius * 1000 > distance) {
          markers.add(marker);
        }
      }
    }
    return markers;
  }
}
