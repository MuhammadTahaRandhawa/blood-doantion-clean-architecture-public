part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class UserDataSubmittedRemotly extends UserEvent {
  final User user;

  UserDataSubmittedRemotly({required this.user});
}

class UserDataFetchedRemotly extends UserEvent {}

class UserProfileImageSubmitted extends UserEvent {
  final File profileImage;

  UserProfileImageSubmitted(this.profileImage);
}

class UserLocationUpdated extends UserEvent {
  final Location location;

  UserLocationUpdated(this.location);
}

class UserFcmTokenUpdated extends UserEvent {
  final String fcmToken;

  UserFcmTokenUpdated(this.fcmToken);
}

class BloodDonationDocRefPosted extends UserEvent {
  final String docRef;

  BloodDonationDocRefPosted(this.docRef);
}

class OtherUserDataFethed extends UserEvent {
  final String userId;

  OtherUserDataFethed(this.userId);
}
