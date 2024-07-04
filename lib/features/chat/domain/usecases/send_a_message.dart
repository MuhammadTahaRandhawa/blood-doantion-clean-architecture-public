import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/domain/repositories/message_repository.dart';

class SendAMessage implements Usecase<Unit, SendAMessageParams> {
  final MessageRepository messageRepository;

  SendAMessage(this.messageRepository);
  @override
  Future<Either<Failure, Unit>> call(SendAMessageParams params) async {
    return await messageRepository.sendMessage(params.chat, params.message);
  }
}

class SendAMessageParams {
  final Chat chat;
  final Message message;

  SendAMessageParams({required this.chat, required this.message});
}
