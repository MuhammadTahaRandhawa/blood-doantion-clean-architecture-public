import 'package:flutter/material.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/presentation/helpers/chat_helpers.dart';
import 'package:myapp/features/chat/presentation/pages/messages_page.dart';
import 'package:myapp/core/widgets/unread_messages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatCard extends StatelessWidget {
  final Chat chat;
  final int? unreadMessages;

  const ChatCard({
    super.key,
    required this.chat,
    required this.unreadMessages,
  });

  @override
  Widget build(BuildContext context) {
    final lastMessage = chat.lastMessageSentBy == chat.currentUserId
        ? '${AppLocalizations.of(context)!.chatCard_you} ${chat.lastMessage}'
        : '${chat.otherUserName}: ${chat.lastMessage}';
    final lastMessageTime =
        ChatHelpers.convertChatDateTimeToString(chat.lastMessageDateTime);

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MessagesPage(chat: chat),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: chat.otherUserImageUrl != null
                  ? NetworkImage(chat.otherUserImageUrl!)
                  : null,
              child: chat.otherUserImageUrl == null
                  ? Text(chat.otherUserName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.otherUserName,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    lastMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  lastMessageTime,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (unreadMessages! > 0)
                  UnreadMessagesContainer(
                      numberOfUnreadMessages: unreadMessages!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
