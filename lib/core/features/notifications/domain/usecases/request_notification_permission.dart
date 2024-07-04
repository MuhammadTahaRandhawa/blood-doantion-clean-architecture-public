import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/notifications/domain/repository/notification_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class RequestNotificationPermission
    implements Usecase<AuthorizationStatus, Unit> {
  final NotificationRepository notificationRepository;

  RequestNotificationPermission(this.notificationRepository);

  @override
  Future<Either<Failure, AuthorizationStatus>> call(Unit params) async {
    return await notificationRepository.requestUserForNotificationsPermission();
  }
}
