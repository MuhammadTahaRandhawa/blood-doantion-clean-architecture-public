import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/location/data/models/location_model.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:uuid/uuid.dart';

const Uuid uuidMap = Uuid();

class MapMarkerModel extends MapMarker {
  MapMarkerModel(
      {required super.markerId,
      required super.userId,
      required super.bloodGroup,
      required super.userName,
      required super.phoneNo,
      required super.fcmToken,
      required super.location,
      required super.mapMarkerType,
      required super.icon,
      required super.isActive,
      required super.rating});

  static MapMarkerModel fromJson({
    required Map<String, dynamic> map,
    required MapMarkerType mapMarkerType,
    required BitmapDescriptor icon,
  }) {
    final GeoPoint geoPoint = map['position']['geopoint'];
    final LatitudeLongitude latitudeLongitude =
        GeoFlutterFireConversion.fromGeoPoint(geoPoint);

    final data = _getData(map, mapMarkerType);

    return MapMarkerModel(
        markerId: data['markerId'],
        userId: data['userId'],
        bloodGroup: data['bloodGroup'],
        userName: data['userName'],
        phoneNo: data['phoneNo'],
        fcmToken: data['fcmToken'],
        location: LocationModel(
            latitude: latitudeLongitude.latitude,
            longitude: latitudeLongitude.longitude,
            address: mapMarkerType == MapMarkerType.center
                ? map['centerAddress']
                : map['address'] ?? "address"),
        mapMarkerType: mapMarkerType,
        icon: icon,
        isActive: map['isActive'] ?? true,
        rating: 0);
  }

  static Map<String, dynamic> _getData(
      Map<String, dynamic> map, MapMarkerType mapMarkerType) {
    switch (mapMarkerType) {
      case MapMarkerType.donation:
        return {
          'userId': map['userId'],
          'bloodGroup': map['bloodGroup'],
          'userName': map['userName'],
          'phoneNo': map['phoneNo'],
          'fcmToken': map['fcmToken'],
          'markerId': map['donationId']
        };
      case MapMarkerType.request:
        return {
          'userId': map['userId'],
          'bloodGroup': map['bloodGroup'],
          'userName': map['requesterName'],
          'phoneNo': map['phoneNo'],
          'fcmToken': map['fcmToken'],
          'markerId': map['requestId'],
        };

      case MapMarkerType.center:
        return {
          'userId': map['centerId'],
          'userName': map['centerName'],
          'phoneNo': map['centerPhone'],
          'markerId': map['centerId']
        };
      default:
        throw ArgumentError();
    }
  }
}
