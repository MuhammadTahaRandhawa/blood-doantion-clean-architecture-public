import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

class UserModel extends User {
  UserModel(
      {required super.userId,
      required super.userName,
      required super.dob,
      required super.phoneNo,
      required super.email,
      required super.cnic,
      required super.gender,
      required super.bloodGroup,
      required super.location,
      super.fcmToken,
      super.userProfileImageUrl});

  factory UserModel.fromJson(Map<String, dynamic> map, [bool isLocal = false]) {
    late LatitudeLongitude latitudeLongitude;
    if (isLocal) {
      latitudeLongitude = LatitudeLongitude(
          latitude: map['position']['latitude'],
          longitude: map['position']['longitude']);
    } else {
      final GeoPoint geoPoint = map['position']['geopoint'];
      latitudeLongitude = GeoFlutterFireConversion.fromGeoPoint(geoPoint);
    }

    return UserModel(
      userId: map['userId'],
      userName: map['userName'],
      dob: isLocal ? DateTime.parse(map['dob']) : map['dob'].toDate(),
      phoneNo: map['phoneNo'],
      email: map['email'],
      cnic: map['cnic'],
      gender: map['gender'],
      bloodGroup: map['bloodGroup'],
      location: Location(
          latitude: latitudeLongitude.latitude,
          longitude: latitudeLongitude.longitude,
          address: map['address']),
      fcmToken: map['fcmToken'],
      userProfileImageUrl: map['userProfileImageUrl'],
    );
  }

  Map<String, dynamic> toJson([bool isLocal = false]) {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'dob': isLocal ? dob.toIso8601String() : dob,
      'phoneNo': phoneNo,
      'cnic': cnic,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'position': isLocal
          ? {'latitude': location.latitude, 'longitude': location.longitude}
          : GeoFlutterFireConversion.toFirePoint(
                  location.latitude, location.longitude)
              .data,
      'address': location.address,
      'fcmToken': fcmToken,
      'userProfileImageUrl': userProfileImageUrl,
    };
  }

  factory UserModel.fromUser(User user) {
    return UserModel(
        userId: user.userId,
        userName: user.userName,
        dob: user.dob,
        phoneNo: user.phoneNo,
        email: user.email,
        cnic: user.cnic,
        gender: user.gender,
        bloodGroup: user.bloodGroup,
        location: user.location,
        fcmToken: user.fcmToken,
        userProfileImageUrl: user.userProfileImageUrl);
  }
}
