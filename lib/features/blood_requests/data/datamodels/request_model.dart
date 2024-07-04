import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';

class RequestModel extends Request {
  RequestModel(
      {required super.requestId,
      required super.userId,
      required super.requesterName,
      required super.phoneNo,
      required super.hospital,
      required super.location,
      required super.requestDateTime,
      required super.bloodGroup,
      required super.bloodBags,
      required super.fcmToken,
      required super.isActive,
      required super.rating,
      required super.userProfileImageUrl,
      required super.requestCase});

  factory RequestModel.fromJson(Map<String, dynamic> map,
      [bool isLocal = false]) {
    late LatitudeLongitude latitudeLongitude;
    if (isLocal) {
      latitudeLongitude = LatitudeLongitude(
          latitude: map['position']['latitude'],
          longitude: map['position']['longitude']);
    } else {
      final GeoPoint geoPoint = map['position']['geopoint'];
      latitudeLongitude = GeoFlutterFireConversion.fromGeoPoint(geoPoint);
    }

    return RequestModel(
        requestId: map['requestId'],
        bloodBags: map['bloodBags'],
        fcmToken: map['fcmToken'],
        rating: map['rating'],
        isActive: map['isActive'],
        userProfileImageUrl: map['userProfileImageUrl'],
        userId: map['userId'],
        requesterName: map['requesterName'],
        phoneNo: map['phoneNo'],
        hospital: map[''] ?? '',
        location: Location(
            latitude: latitudeLongitude.latitude,
            longitude: latitudeLongitude.longitude,
            address: map['address']),
        requestDateTime: isLocal
            ? DateTime.parse(map['requestDateTime'])
            : map['requestDateTime'].toDate(),
        bloodGroup: map['bloodGroup'],
        requestCase:
            Appointment.getAppointmentCaseFromString(map['requestCase']));
  }

  Map<String, dynamic> toJson([bool isLocal = false]) {
    return {
      'requestId': requestId,
      'userId': userId,
      'requesterName': requesterName,
      'phoneNo': phoneNo,
      'hospital': hospital,
      'requestDateTime':
          isLocal ? requestDateTime.toIso8601String() : requestDateTime,
      'bloodGroup': bloodGroup,
      'position': isLocal
          ? {'latitude': location.latitude, 'longitude': location.longitude}
          : GeoFlutterFireConversion.toFirePoint(
                  location.latitude, location.longitude)
              .data,
      'address': location.address,
      'bloodBags': bloodBags,
      'fcmToken': fcmToken,
      'rating': rating,
      'isActive': isActive,
      'userProfileImageUrl': userProfileImageUrl,
      'requestCase': Appointment.getAppointmentCaseAsString(requestCase)
    };
  }

  factory RequestModel.fromRequest(Request request) {
    return RequestModel(
        requestId: request.requestId,
        userId: request.userId,
        requesterName: request.requesterName,
        phoneNo: request.phoneNo,
        hospital: request.hospital,
        location: request.location,
        requestDateTime: request.requestDateTime,
        bloodGroup: request.bloodGroup,
        bloodBags: request.bloodBags,
        fcmToken: request.fcmToken,
        isActive: request.isActive,
        rating: request.rating,
        userProfileImageUrl: request.userProfileImageUrl,
        requestCase: request.requestCase);
  }
}
