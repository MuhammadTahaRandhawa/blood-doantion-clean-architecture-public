import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/repositories/message_repository.dart';

class MarkMessagesAsViewed implements Usecase<Unit, Chat> {
  final MessageRepository messageRepository;

  MarkMessagesAsViewed(this.messageRepository);

  @override
  Future<Either<Failure, Unit>> call(Chat params) async {
    return await messageRepository.markMessagesAsViewed(params);
  }
}
