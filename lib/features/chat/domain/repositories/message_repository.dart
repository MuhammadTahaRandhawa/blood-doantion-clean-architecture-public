import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';

abstract interface class MessageRepository {
  Either<Failure, Stream<List<Message>>> fetchMessagesFromAChat(String chatId);
  Future<Either<Failure, Unit>> sendMessage(Chat chat, Message message);
  Either<Failure, Stream<Map<String, int>>> fetchUnreadMessagesCount();
  Future<Either<Failure, Unit>> markMessagesAsViewed(Chat chat);
  Future<Either<Failure, Unit>> sendApprovedMessage(Chat chat, Message message);
}
