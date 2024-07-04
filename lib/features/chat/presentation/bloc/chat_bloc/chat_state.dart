part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatsOfCurrentUserFetchFailure extends ChatState {
  final String message;

  ChatsOfCurrentUserFetchFailure(this.message);
}

final class ChatsOfCurrentUserFetchSuccess extends ChatState {
  final Stream<List<Chat>> chats;

  ChatsOfCurrentUserFetchSuccess(this.chats);
}

final class ChatsOfCurrentUserFetchLoading extends ChatState {}

final class MessagesFromChatFetchLoading extends ChatState {}

final class MessagesFromChatFetchSuccess extends ChatState {
  final Stream<List<Message>> messages;

  MessagesFromChatFetchSuccess(this.messages);
}

final class MessagesFromChatFetchFailure extends ChatState {
  final String message;

  MessagesFromChatFetchFailure(this.message);
}

final class SendAMessageLoading extends ChatState {}

final class SendAMessageSuccess extends ChatState {}

final class SendAMessageFailure extends ChatState {
  final String message;

  SendAMessageFailure(this.message);
}

final class SendAnApprovedMessageSuccess extends ChatState {}

final class SendAnApprovedMessageFailure extends ChatState {
  final String message;

  SendAnApprovedMessageFailure(this.message);
}
