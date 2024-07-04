part of 'basic_information_bloc.dart';

@immutable
sealed class BasicInformationEvent {}

class UserDataSubmitted extends BasicInformationEvent {
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

  UserDataSubmitted(
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
}
