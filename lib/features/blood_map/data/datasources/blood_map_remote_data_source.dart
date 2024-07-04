import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/get_bytes_from_assets.dart';
import 'package:myapp/features/blood_map/data/models/map_marker_model.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';

abstract interface class BloodMapRemoteDataSource {
  Future<List<MapMarkerModel>> fetchRequestsMapMarkersAroundUser(
      LatitudeLongitude latitudeLongitude);
  Future<List<MapMarkerModel>> fetchDonationsMapMarkersAroundUser(
      LatitudeLongitude latitudeLongitude);
  Future<List<MapMarkerModel>> fetchCentersMapMarkersAroundUser(
      LatitudeLongitude latitudeLongitude);
}

class BloodMapRemoteDataSourceImpl implements BloodMapRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  BloodMapRemoteDataSourceImpl(this.firebaseFirestore);
  @override
  Future<List<MapMarkerModel>> fetchRequestsMapMarkersAroundUser(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final Uint8List requestIconBytes = await getBytesFromAsset(
          kIsWeb
              ? 'images/blood_request_marker.png'
              : 'assets/images/blood_request_marker.png',
          300);
      final requestIcon = BitmapDescriptor.fromBytes(requestIconBytes);
      final requestsCollection = firebaseFirestore.collection('requests');
      final geo = GeoFlutterFire();
      GeoFirePoint center = geo.point(
          latitude: latitudeLongitude.latitude,
          longitude: latitudeLongitude.longitude);

      List<DocumentSnapshot<Object?>> docList = [];

      await for (List<DocumentSnapshot<Object?>> snapshots
          in geo.collection(collectionRef: requestsCollection).within(
                center: center,
                radius: 32,
                field: 'position',
                strictMode: true,
              )) {
        if (snapshots.isEmpty) {
          if (kDebugMode) {
            print('empty');
          }
          break; // Exit the loop if no more documents are available
        }
        docList.addAll(snapshots);
        return _convertToMarkers(docList, requestIcon, MapMarkerType.request);
      }

// Use the function to convert and return markers
      return _convertToMarkers(docList, requestIcon, MapMarkerType.request);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MapMarkerModel>> fetchDonationsMapMarkersAroundUser(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final Uint8List donorIconBytes = await getBytesFromAsset(
          kIsWeb
              ? 'images/blood_donor_marker.png'
              : 'assets/images/blood_donor_marker.png',
          300);
      final donorIcon = BitmapDescriptor.fromBytes(donorIconBytes);
      final donationsCollection = firebaseFirestore.collection('donations');
      final geo = GeoFlutterFire();
      GeoFirePoint center = geo.point(
          latitude: latitudeLongitude.latitude,
          longitude: latitudeLongitude.longitude);

      List<DocumentSnapshot<Object?>> docList = [];

      await for (List<DocumentSnapshot<Object?>> snapshots
          in geo.collection(collectionRef: donationsCollection).within(
                center: center,
                radius: 32,
                field: 'position',
                strictMode: true,
              )) {
        if (snapshots.isEmpty) {
          break; // Exit the loop if no more documents are available
        }

        docList.addAll(snapshots);
        // Use the function to convert and return markers
        return _convertToMarkers(docList, donorIcon, MapMarkerType.donation);
      }

// Use the function to convert and return markers
      return _convertToMarkers(docList, donorIcon, MapMarkerType.donation);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MapMarkerModel>> fetchCentersMapMarkersAroundUser(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final Uint8List centerIconBytes = await getBytesFromAsset(
          kIsWeb
              ? 'images/hospital_marker.png'
              : 'assets/images/hospital_marker.png',
          300);
      final centerIcon = BitmapDescriptor.fromBytes(centerIconBytes);
      final donationsCollection = firebaseFirestore.collection('centers');
      final geo = GeoFlutterFire();
      GeoFirePoint center = geo.point(
          latitude: latitudeLongitude.latitude,
          longitude: latitudeLongitude.longitude);

      List<DocumentSnapshot<Object?>> docList = [];

      await for (List<DocumentSnapshot<Object?>> snapshots
          in geo.collection(collectionRef: donationsCollection).within(
                center: center,
                radius: 32,
                field: 'position',
                strictMode: true,
              )) {
        if (snapshots.isEmpty) {
          break; // Exit the loop if no more documents are available
        }

        docList.addAll(snapshots);
        // Use the function to convert and return markers
        return _convertToMarkers(docList, centerIcon, MapMarkerType.center);
      }

// Use the function to convert and return markers
      return _convertToMarkers(docList, centerIcon, MapMarkerType.center);
    } catch (e, stack) {
      log(e.toString());
      print(stack);
      throw ServerException(e.toString());
    }
  }

  // Function to convert DocumentSnapshot to MapMarkerModel
  List<MapMarkerModel> _convertToMarkers(
      List<DocumentSnapshot<Object?>> docs, icon, MapMarkerType mapMarkerType) {
    return docs
        .map((doc) => MapMarkerModel.fromJson(
              icon: icon,
              mapMarkerType: mapMarkerType,
              map: doc.data() as Map<String, dynamic>,
            ))
        .toList();
  }
}
