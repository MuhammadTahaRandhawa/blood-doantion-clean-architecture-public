import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/stream_usecase.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/domain/repositories/message_repository.dart';

class FetchMessagesFromChat implements StreamUseCase<List<Message>, String> {
  final MessageRepository messageRepository;

  FetchMessagesFromChat(this.messageRepository);
  @override
  Either<Failure, Stream<List<Message>>> call(String params) {
    return messageRepository.fetchMessagesFromAChat(params);
  }
}
