import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/notifications/domain/entities/notification_data.dart';
import 'package:myapp/core/features/notifications/domain/repository/notification_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class SendScheduleNotification
    implements Usecase<Unit, ScheduledNotificationParams> {
  final NotificationRepository notificationRepository;

  SendScheduleNotification(this.notificationRepository);
  @override
  Future<Either<Failure, Unit>> call(ScheduledNotificationParams params) async {
    return await notificationRepository.sendAnScheduledNotification(
        params.notificationData, params.dateTime);
  }
}

class ScheduledNotificationParams {
  final NotificationData notificationData;
  final DateTime dateTime;

  ScheduledNotificationParams(this.notificationData, this.dateTime);
}
