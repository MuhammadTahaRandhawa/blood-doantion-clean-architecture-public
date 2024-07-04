import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/domain/usecases/fetch_messages_from_chat.dart';
import 'package:myapp/features/chat/domain/usecases/mark_messages_as_viewed.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, Stream<List<Message>>> {
  final FetchMessagesFromChat fetchMessagesFromChat;
  final MarkMessagesAsViewed markMessagesAsViewed;
  late final StreamSubscription<List<Message>> messageSubscription;
  MessageBloc(this.fetchMessagesFromChat, this.markMessagesAsViewed)
      : super(const Stream<List<Message>>.empty()) {
    on<MessagesOFAChatFetched>((event, emit) {
      final response = fetchMessagesFromChat.call(event.chat.chatId);
      response.fold((l) => null, (r) {
        emit(r);
      });
    });
    on<MessagesViewedMarked>((event, emit) async {
      await markMessagesAsViewed.call(event.chat);
    });
    on<DisposeMessagesStream>((event, emit) => close());
  }
}
