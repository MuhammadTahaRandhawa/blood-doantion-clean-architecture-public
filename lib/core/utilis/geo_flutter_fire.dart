import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class GeoFlutterFireConversion {
  static GeoFirePoint toFirePoint(double lat, double long) =>
      GeoFirePoint(lat, long);

  static LatitudeLongitude fromFirePoint(GeoFirePoint geoFirePoint) =>
      LatitudeLongitude(
          latitude: geoFirePoint.latitude, longitude: geoFirePoint.longitude);

  static LatitudeLongitude fromGeoPoint(GeoPoint geoPoint) => LatitudeLongitude(
      latitude: geoPoint.latitude, longitude: geoPoint.longitude);
}

class LatitudeLongitude {
  final double latitude;
  final double longitude;

  LatitudeLongitude({required this.latitude, required this.longitude});
}
