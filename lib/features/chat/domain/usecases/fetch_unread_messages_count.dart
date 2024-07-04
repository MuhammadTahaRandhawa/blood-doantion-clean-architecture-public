import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/stream_usecase.dart';
import 'package:myapp/features/chat/domain/repositories/message_repository.dart';

class FetchUnreadMessagesCount
    implements StreamUseCase<Map<String, int>, Unit> {
  final MessageRepository messageRepository;

  FetchUnreadMessagesCount(this.messageRepository);
  @override
  Either<Failure, Stream<Map<String, int>>> call(Unit params) {
    return messageRepository.fetchUnreadMessagesCount();
  }
}
