part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class NotificationsPermissionRequested extends NotificationEvent {}

class NotificationDeviceFcmTokenRequested extends NotificationEvent {}

class LocalNotificationsInitialized extends NotificationEvent {
  final RemoteMessage remoteMessage;
  final BuildContext context;

  LocalNotificationsInitialized(this.remoteMessage, this.context);
}

class LocalNotificationDisplayed extends NotificationEvent {
  final RemoteMessage remoteMessage;

  LocalNotificationDisplayed(this.remoteMessage);
}

class FirebaseMessagingInitialized extends NotificationEvent {
  final User user;
  final BuildContext context;

  FirebaseMessagingInitialized(this.user, this.context);
}

class FcmTokenRefreshListened extends NotificationEvent {}

class SetupInteractedMessage extends NotificationEvent {
  final BuildContext context;

  SetupInteractedMessage(this.context);
}

class NotificationMessageHandled extends NotificationEvent {
  final RemoteMessage remoteMessage;
  final BuildContext context;

  NotificationMessageHandled(this.remoteMessage, this.context);
}

class NotificationFromOneDeviceToAnotherSent extends NotificationEvent {
  final Chat chat;
  final Message message;

  NotificationFromOneDeviceToAnotherSent(this.chat, this.message);
}

class ScheduledNotificationSent extends NotificationEvent {
  final NotificationData notificationData;
  final DateTime dateTime;

  ScheduledNotificationSent(this.notificationData, this.dateTime);
}
