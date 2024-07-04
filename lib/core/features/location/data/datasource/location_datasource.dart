import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/features/location/data/models/location_model.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

abstract interface class LocationDataSource {
  Future<void> getLocationPermission();
  Future<Position> getCurrentPosition();
  Future<String> getCurrentAddress(LatitudeLongitude latitudeLongitude);
  Future<LocationModel> getCurrentLocation();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<String> getCurrentAddress(LatitudeLongitude latitudeLongitude) async {
    try {
      var responseJson = await http.get(Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latitudeLongitude.latitude},${latitudeLongitude.longitude}&key=Your Google Maps API'));
      var response = jsonDecode(responseJson.body);
      var address = response['results'][0]['formatted_address'].toString();

      return address;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LocationModel> getCurrentLocation() async {
    late LocationModel locationModel;
    try {
      await getLocationPermission();
      final Position position = await getCurrentPosition();
      final String address = await getCurrentAddress(LatitudeLongitude(
          latitude: position.latitude, longitude: position.longitude));
      locationModel = LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address);
      return locationModel;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Position> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw (ServerException('Location Service is not Enabled'));
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw (ServerException('Location Permission Denied'));
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw (ServerException('Location Permission Denied Permanently'));
      }
      if (kDebugMode) {
        print('Location permission passed');
      }
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ServerException(e.toString());
    }
  }
}
