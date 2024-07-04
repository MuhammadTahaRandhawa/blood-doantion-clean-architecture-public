import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/domain/repositories/message_repository.dart';

class SendApprovedRequest implements Usecase<Unit, SendApprovedRequestParams> {
  final MessageRepository messageRepository;

  SendApprovedRequest(this.messageRepository);
  @override
  Future<Either<Failure, Unit>> call(SendApprovedRequestParams params) async {
    return await messageRepository.sendApprovedMessage(
        params.chat, params.message);
  }
}

class SendApprovedRequestParams {
  final Message message;
  final Chat chat;

  SendApprovedRequestParams({required this.message, required this.chat});
}
