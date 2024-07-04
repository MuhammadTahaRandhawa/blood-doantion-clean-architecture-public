import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';

class SubmitUserDataParams {
  final String userId;
  final String email;
  final String userName;
  final DateTime dob;
  final String phoneNo;
  final String cnic;
  final String gender;
  final String bloodGroup;
  final Location location;
  final String? fcmToken;
  final String? userProfileImageUrl;

  SubmitUserDataParams(
      {required this.userId,
      required this.email,
      required this.userName,
      required this.dob,
      required this.phoneNo,
      required this.cnic,
      required this.gender,
      required this.bloodGroup,
      required this.location,
      this.fcmToken,
      this.userProfileImageUrl});

  User userFromParams() {
    return User(
        userId: userId,
        userName: userName,
        dob: dob,
        phoneNo: phoneNo,
        email: email,
        cnic: cnic,
        gender: gender,
        bloodGroup: bloodGroup,
        location: location,
        fcmToken: fcmToken,
        userProfileImageUrl: userProfileImageUrl);
  }
}
