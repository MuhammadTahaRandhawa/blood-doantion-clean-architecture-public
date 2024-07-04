import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';

class MapMarker {
  final String markerId, userId, userName, phoneNo;

  final String? fcmToken, bloodGroup;
  final Location location;
  final MapMarkerType mapMarkerType;
  final BitmapDescriptor icon;
  final int rating;
  final bool isActive;

  MapMarker(
      {required this.markerId,
      required this.userId,
      required this.bloodGroup,
      required this.userName,
      required this.phoneNo,
      required this.fcmToken,
      required this.location,
      required this.mapMarkerType,
      required this.icon,
      required this.isActive,
      required this.rating});
}

enum MapMarkerType { request, donation, center }
