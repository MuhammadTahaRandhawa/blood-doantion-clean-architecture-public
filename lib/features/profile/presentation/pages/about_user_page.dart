import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/utilis/get_conversation_id.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/presentation/pages/messages_page.dart';
import 'package:myapp/features/profile/presentation/pages/user_profile_page.dart';
import 'package:myapp/features/profile/presentation/widgets/toggle_profile_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutUserPage extends StatelessWidget {
  const AboutUserPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (user.userId == currentUser.userId)
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ));
                },
                icon: const Icon(Icons.edit))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 60,
                foregroundImage: user.userProfileImageUrl != null
                    ? NetworkImage(user.userProfileImageUrl!)
                    : null,
                child: user.userProfileImageUrl == null
                    ? Center(
                        child:
                            Text(AppLocalizations.of(context)!.aboutUser_noImg),
                      )
                    : null,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                user.userName,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white),
                  onPressed: user.userId != currentUser.userId
                      ? () {
                          _gotoMessageScreen(context, currentUser, user);
                        }
                      : null,
                  icon: const Icon(Icons.message),
                  label: Text(AppLocalizations.of(context)!.aboutUser_msg)),
              const SizedBox(
                height: 10,
              ),
              ToggleProfileView(
                user: user,
              )
            ],
          ),
        ),
      ),
    );
  }

  _gotoMessageScreen(BuildContext context, User currentUser, User otherUser) {
    final chat = Chat(
        chatId: getconversationIdHash(currentUser.userId, otherUser.userId),
        currentUserId: currentUser.userId,
        otherUserId: otherUser.userId,
        otherUserName: otherUser.userName,
        currentUserName: currentUser.userName,
        lastMessage: '',
        currentUserImageUrl: currentUser.userProfileImageUrl,
        otherUserImageUrl: otherUser.userProfileImageUrl,
        lastMessageDateTime: DateTime.now(),
        lastMessageSentBy: currentUser.userId,
        currentUserFcmToken: currentUser.fcmToken,
        otherUserFcmToken: otherUser.fcmToken);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MessagesPage(chat: chat),
    ));
  }
}
