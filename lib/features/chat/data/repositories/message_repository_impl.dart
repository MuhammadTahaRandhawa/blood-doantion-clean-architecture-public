import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/chat/data/datasources/messages_remote_data_source.dart';
import 'package:myapp/features/chat/data/models/chat_model.dart';
import 'package:myapp/features/chat/data/models/message_model.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessagesRemoteDataSource messagesRemoteDataSource;

  MessageRepositoryImpl(this.messagesRemoteDataSource);
  @override
  Either<Failure, Stream<List<Message>>> fetchMessagesFromAChat(String chatId) {
    try {
      final response = messagesRemoteDataSource.fetchMessagesFromChat(chatId);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(Chat chat, Message message) async {
    try {
      final response = await messagesRemoteDataSource.sendAMessage(
          ChatModel.fromChat(chat), MessageModel.fromMessage(message));
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Either<Failure, Stream<Map<String, int>>> fetchUnreadMessagesCount() {
    try {
      final response = messagesRemoteDataSource.getUnreadMessagesCount();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> markMessagesAsViewed(Chat chat) async {
    try {
      final response = await messagesRemoteDataSource
          .markMessagesAsViewed(ChatModel.fromChat(chat));
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendApprovedMessage(
      Chat chat, Message message) async {
    try {
      final res = await messagesRemoteDataSource.sendApprovedMessage(
          ChatModel.fromChat(chat), MessageModel.fromMessage(message));
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
