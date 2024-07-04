import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/stream_usecase.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/repositories/chat_repository.dart';

class FetchChatsOfuser implements StreamUseCase<List<Chat>, Unit> {
  final ChatRepository chatRepository;

  FetchChatsOfuser(this.chatRepository);
  @override
  Either<Failure, Stream<List<Chat>>> call(Unit params) {
    return chatRepository.fetchChatsOfCurrentUser();
  }
}
