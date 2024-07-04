import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Donation {
  final String donationId;
  final String userId;
  final String userName;
  final DateTime dob;
  final String phoneNo;
  final String? userProfileImageUrl;
  final String email;
  final String cnic;
  final String gender;
  final String bloodGroup;
  final Location location;
  final String? fcmToken;
  final bool isActive;
  // final int rating;

  Donation({
    String? donationId,
    required this.userId,
    required this.userName,
    required this.isActive,
    required this.dob,
    required this.phoneNo,
    required this.email,
    required this.cnic,
    required this.gender,
    required this.bloodGroup,
    required this.location,
    required this.fcmToken,
    required this.userProfileImageUrl,
    //  required this.rating
  }) : donationId = donationId ?? uuid.v4();
}
