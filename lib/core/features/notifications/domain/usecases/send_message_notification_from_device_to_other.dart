import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/notifications/domain/repository/notification_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';

class SendMessageNotificationFromDeviceToAnother
    implements Usecase<Unit, MessageNotificationParams> {
  final NotificationRepository notificationRepository;

  SendMessageNotificationFromDeviceToAnother(this.notificationRepository);
  @override
  Future<Either<Failure, Unit>> call(MessageNotificationParams params) async {
    return await notificationRepository
        .sendMessageNotificationFromDeviceToOther(params.chat, params.message);
  }
}

class MessageNotificationParams {
  final Message message;
  final Chat chat;

  MessageNotificationParams(
    this.chat,
    this.message,
  );
}
