part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}

class MessagesOFAChatFetched extends MessageEvent {
  final Chat chat;

  MessagesOFAChatFetched(this.chat);
}

class MessagesViewedMarked extends MessageEvent {
  final Chat chat;

  MessagesViewedMarked(this.chat);
}

class DisposeMessagesStream extends MessageEvent {}
