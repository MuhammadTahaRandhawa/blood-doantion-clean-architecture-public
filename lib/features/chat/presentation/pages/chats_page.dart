import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:myapp/features/chat/presentation/cubit/unread_messages_count_cubit.dart';
import 'package:myapp/features/chat/presentation/shimmer/chat_card_shimmer.dart';
import 'package:myapp/features/chat/presentation/widgets/chat_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<List<Chat>>? chatStream;
  Map<String, int> unreadMesages = {};

  @override
  void initState() {
    context.read<ChatBloc>().add(ChatofCurrentUserFetched());
    // context.read<UnreadMessagesCountCubit>().unreadMessagesCountFetched();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatsOfCurrentUserFetchFailure) {
          showSnackBar(context, state.message);
        }
        if (state is ChatsOfCurrentUserFetchSuccess) {
          chatStream = state.chats;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.chatPage_appBar),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: chatStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Chat> chats = snapshot.data!;
                        if (chats.isEmpty) {
                          return Center(
                            child: Text(
                                AppLocalizations.of(context)!.chatPage_noChat),
                          );
                        }
                        return BlocBuilder<UnreadMessagesCountCubit,
                            Map<String, int>>(builder: (context, state) {
                          //log('chat state' + state.toString());
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Stack(children: [
                                  ChatCard(
                                    chat: chats[index],
                                    unreadMessages: state.containsKey(
                                            chats[index].otherUserId)
                                        ? state[chats[index].otherUserId]
                                        : 0,
                                  ),
                                ]);
                              },
                              itemCount: chats.length,
                            ),
                          );
                        });
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) =>
                            const ChatCardShimmer(),
                        itemCount: 10,
                      );
                    }),
              )
            ],
          ),
        );
      },
    );
  }
}
