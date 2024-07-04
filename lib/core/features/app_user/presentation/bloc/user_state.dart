part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserSubmittedLoading extends UserState {}

final class UserSubmittedSuccess extends UserState {}

final class UserSubmittedFailure extends UserState {
  final String message;

  UserSubmittedFailure(this.message);
}

final class UserFetchedLoading extends UserState {}

final class UserFetchedSuccess extends UserState {
  final User user;

  UserFetchedSuccess(this.user);
}

final class UserFetchedFailure extends UserState {
  final String message;

  UserFetchedFailure(this.message);
}

final class UserProfileImageSubmitFailure extends UserState {
  final String message;

  UserProfileImageSubmitFailure(this.message);
}

final class UserProfileImageSubmitSuccess extends UserState {
  final String imageUrl;

  UserProfileImageSubmitSuccess(this.imageUrl);
}

final class UserLocationUpdatedSuccess extends UserState {}

final class UserLocationUpdatedFailure extends UserState {
  final String message;

  UserLocationUpdatedFailure(this.message);
}

final class BloodDonationDocRefPostSuccess extends UserState {}

final class BloodDonationDocRefPostFailure extends UserState {
  final String message;

  BloodDonationDocRefPostFailure(this.message);
}

final class UserFcmTokenUpdatedSuccess extends UserState {}

final class UserFcmTokenUpdatedFailure extends UserState {
  final String message;

  UserFcmTokenUpdatedFailure(this.message);
}

final class OtherUserDataFetchedSuccess extends UserState {
  final User user;

  OtherUserDataFetchedSuccess(this.user);
}

final class OtherUserDataFetchedFailure extends UserState {
  final String message;

  OtherUserDataFetchedFailure(this.message);
}

final class OtherUserDataFetchedLoading extends UserState {}
