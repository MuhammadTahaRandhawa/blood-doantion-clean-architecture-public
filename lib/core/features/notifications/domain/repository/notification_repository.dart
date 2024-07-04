import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/notifications/domain/entities/notification_data.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, String>> getDeviceFcmToken();
  Future<Either<Failure, AuthorizationStatus>>
      requestUserForNotificationsPermission();
  Future<Either<Failure, Unit>> sendMessageNotificationFromDeviceToOther(
      Chat chat, Message message);
  Future<Either<Failure, Unit>> sendAnScheduledNotification(
      NotificationData notificationData, DateTime dateTime);
}
