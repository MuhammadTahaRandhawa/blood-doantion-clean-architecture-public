import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/notifications/domain/repository/notification_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class GetFcmToken implements Usecase<String, Unit> {
  final NotificationRepository notificationRepository;

  GetFcmToken(this.notificationRepository);

  @override
  Future<Either<Failure, String>> call(Unit params) async {
    return await notificationRepository.getDeviceFcmToken();
  }
}
