import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/domain/usecases/fetch_chats_of_user.dart';
import 'package:myapp/features/chat/domain/usecases/fetch_messages_from_chat.dart';
import 'package:myapp/features/chat/domain/usecases/mark_messages_as_viewed.dart';
import 'package:myapp/features/chat/domain/usecases/send_a_message.dart';
import 'package:myapp/features/chat/domain/usecases/send_approved_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchChatsOfuser fetchChatsOfuser;
  final FetchMessagesFromChat fetchMessagesFromChat;
  final MarkMessagesAsViewed markMessagesAsViewed;
  final SendApprovedRequest sendApprovedRequest;

  final SendAMessage sendAMessage;
  ChatBloc(
    this.fetchChatsOfuser,
    this.fetchMessagesFromChat,
    this.sendAMessage,
    this.markMessagesAsViewed,
    this.sendApprovedRequest,
  ) : super(ChatInitial()) {
    on<ChatofCurrentUserFetched>((event, emit) {
      emit(ChatsOfCurrentUserFetchLoading());
      final response = fetchChatsOfuser.call(unit);
      response.fold((l) => emit(ChatsOfCurrentUserFetchFailure(l.message)),
          (r) => emit(ChatsOfCurrentUserFetchSuccess(r)));
    });
    on<MessagesFromAChatFetched>((event, emit) {
      emit(MessagesFromChatFetchLoading());
      final response = fetchMessagesFromChat.call(event.chatId);
      response.fold((l) => emit(MessagesFromChatFetchFailure(l.message)),
          (r) => emit(MessagesFromChatFetchSuccess(r)));
    });
    on<SentANewMessage>((event, emit) async {
      emit(SendAMessageLoading());
      final response = await sendAMessage
          .call(SendAMessageParams(chat: event.chat, message: event.message));
      response.fold((l) => emit(SendAMessageFailure(l.message)),
          (r) => emit(SendAMessageSuccess()));
    });
    on<SendApprovedMessage>((event, emit) async {
      emit(SendAMessageLoading());
      final res = await sendApprovedRequest.call(
          SendApprovedRequestParams(message: event.message, chat: event.chat));
      res.fold((l) => emit(SendAnApprovedMessageFailure(l.message)),
          (r) => emit(SendAnApprovedMessageSuccess()));
    });
  }
  @override
  void onTransition(Transition<ChatEvent, ChatState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
