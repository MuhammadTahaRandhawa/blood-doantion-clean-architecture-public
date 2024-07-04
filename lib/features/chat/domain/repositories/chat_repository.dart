import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';

abstract interface class ChatRepository {
  Either<Failure, Stream<List<Chat>>> fetchChatsOfCurrentUser();
}
