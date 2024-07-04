import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/presentation/helpers/chat_helpers.dart';

class TextMessagesBubble extends StatelessWidget {
  final Message message;
  final User currentUser;
  final bool isFirst;

  const TextMessagesBubble.isFirst(
      {super.key, required this.message, required this.currentUser})
      : isFirst = true;
  const TextMessagesBubble.other(
      {super.key, required this.message, required this.currentUser})
      : isFirst = false;

  @override
  Widget build(BuildContext context) {
    return message.sentBy == currentUser.userId
        ? _buildSenderBubble(context)
        : _buildReceiverBubble(context);
  }

  Widget _buildSenderBubble(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.only(
            topRight: isFirst ? Radius.zero : const Radius.circular(20),
            topLeft: const Radius.circular(20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                textAlign: TextAlign.left,
                message.text!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ChatHelpers.convertChatDateTimeToString(message.timeSent),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  message.isViewed
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.checkmark_alt_circle,
                  size: Theme.of(context).textTheme.labelSmall!.fontSize,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverBubble(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? Radius.zero : const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                textAlign: TextAlign.left,
                message.text!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer)),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(ChatHelpers.convertChatDateTimeToString(message.timeSent),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
