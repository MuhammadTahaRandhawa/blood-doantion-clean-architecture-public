part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class ChatofCurrentUserFetched extends ChatEvent {}

class MessagesFromAChatFetched extends ChatEvent {
  final String chatId;

  MessagesFromAChatFetched(this.chatId);
}

class SentANewMessage extends ChatEvent {
  final Chat chat;
  final Message message;

  SentANewMessage(this.chat, this.message);
}

class SendApprovedMessage extends ChatEvent {
  final Chat chat;
  final Message message;

  SendApprovedMessage(this.chat, this.message);
}

// class MessagesViewedMarked extends ChatEvent {
//   final Chat chat;

//   MessagesViewedMarked(this.chat);
// }
