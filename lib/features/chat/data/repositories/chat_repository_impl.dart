import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;
  ChatRepositoryImpl(this.chatRemoteDataSource);
  @override
  Either<Failure, Stream<List<Chat>>> fetchChatsOfCurrentUser() {
    try {
      final response = chatRemoteDataSource.fethChatsOfCurrentUser();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
