import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/notifications/data/datasources/notification_data_source.dart';
import 'package:myapp/core/features/notifications/domain/entities/notification_data.dart';
import 'package:myapp/core/features/notifications/domain/repository/notification_repository.dart';
import 'package:myapp/features/chat/data/models/chat_model.dart';
import 'package:myapp/features/chat/data/models/message_model.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource notificationDataSource;

  NotificationRepositoryImpl(this.notificationDataSource);

  @override
  Future<Either<Failure, String>> getDeviceFcmToken() async {
    try {
      final response = await notificationDataSource.getFcmTokenOfDevice();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, AuthorizationStatus>>
      requestUserForNotificationsPermission() async {
    try {
      final response =
          await notificationDataSource.requestNotificationPermissions();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessageNotificationFromDeviceToOther(
      Chat chat, Message message) async {
    try {
      final response = await notificationDataSource
          .sendMessageNotificationFromOneDeviceToAnother(
              ChatModel.fromChat(chat), MessageModel.fromMessage(message));
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendAnScheduledNotification(
      NotificationData notificationData, DateTime dateTime) async {
    try {
      final res = await notificationDataSource.sendScheduledNotification(
          notificationData, dateTime);
      return (right(res));
    } on ServerException catch (e) {
      return (left(Failure(e.exceptionMessage)));
    }
  }
}
