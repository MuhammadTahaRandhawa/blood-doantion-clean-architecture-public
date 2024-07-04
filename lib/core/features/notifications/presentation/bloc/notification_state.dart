part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationPermissionLoading extends NotificationState {}

final class NotificationPermissionSuccess extends NotificationState {}

final class NotificationPermissionFailure extends NotificationState {
  final String message;

  NotificationPermissionFailure(this.message);
}

final class InteractedMessageRecieved extends NotificationState {
  final RemoteMessage remoteMessage;

  InteractedMessageRecieved(this.remoteMessage);
}

final class GetFcmTokenLoading extends NotificationState {}

final class GetFcmTokenFailure extends NotificationState {
  final String message;

  GetFcmTokenFailure(this.message);
}

final class GetFcmTokenSuccess extends NotificationState {
  final String fcmToken;

  GetFcmTokenSuccess(this.fcmToken);
}

final class ScheduledNotificationSentSuccess extends NotificationState {}

final class ScheduledNotificationSentFailure extends NotificationState {
  final String message;

  ScheduledNotificationSentFailure(this.message);
}
