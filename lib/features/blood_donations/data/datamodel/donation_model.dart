import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';

class DonationModel extends Donation {
  DonationModel({
    required super.donationId,
    required super.userId,
    required super.userName,
    required super.dob,
    required super.phoneNo,
    required super.email,
    required super.cnic,
    required super.gender,
    required super.bloodGroup,
    required super.location,
    required super.fcmToken,
    required super.isActive,
    required super.userProfileImageUrl,
    // required super.rating
  });

  Map<String, dynamic> toJson() {
    return {
      'donationId': donationId,
      'userId': userId,
      'userName': userName,
      'email': email,
      'dob': dob,
      'phoneNo': phoneNo,
      'cnic': cnic,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'position': GeoFlutterFireConversion.toFirePoint(
              location.latitude, location.longitude)
          .data,
      'address': location.address,
      'fcmToken': fcmToken,
      'userProfileImageUrl': userProfileImageUrl,
      'isActive': isActive,
      //'rating': 0,
    };
  }

  factory DonationModel.fromJson(Map<String, dynamic> map) {
    final GeoPoint geoPoint = map['position']['geopoint'];
    final LatitudeLongitude latitudeLongitude =
        GeoFlutterFireConversion.fromGeoPoint(geoPoint);
    return DonationModel(
      donationId: map['donationId'],
      isActive: map['isActive'],
      userId: map['userId'],
      userName: map['userName'],
      dob: map['dob'].toDate(),
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
      // rating: map['rating'],
    );
  }
  factory DonationModel.fromDonation(Donation donation) {
    return DonationModel(
        donationId: donation.donationId,
        //rating: donation.rating,
        isActive: donation.isActive,
        userId: donation.userId,
        userName: donation.userName,
        dob: donation.dob,
        phoneNo: donation.phoneNo,
        email: donation.email,
        cnic: donation.cnic,
        gender: donation.gender,
        bloodGroup: donation.bloodGroup,
        location: donation.location,
        fcmToken: donation.fcmToken,
        userProfileImageUrl: donation.userProfileImageUrl);
  }
}
