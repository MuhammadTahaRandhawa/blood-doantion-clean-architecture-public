import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/widgets/unread_messages.dart';
import 'package:myapp/features/chat/presentation/cubit/unread_messages_count_cubit.dart';
import 'package:myapp/features/chat/presentation/pages/chats_page.dart';

final PreferredSizeWidget homeAppBar = AppBar(
  actions: [
    BlocBuilder<UnreadMessagesCountCubit, Map<String, int>>(
      builder: (context, state) {
        // log(state.toString());
        return InkWell(
          child: Stack(
            children: [
              IconButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChatPage(),
                    ));
                  },
                  icon: const Icon(CupertinoIcons.chat_bubble)),
              if (state.isNotEmpty)
                Positioned(
                    child: UnreadMessagesContainer(
                        numberOfUnreadMessages: state.length))
            ],
          ),
        );
      },
    ),
    const SizedBox(
      width: 20,
    ),
  ],
);
