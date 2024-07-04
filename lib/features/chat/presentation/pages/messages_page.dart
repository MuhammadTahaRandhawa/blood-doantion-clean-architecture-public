import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/presentation/bloc/report_bloc.dart';
import 'package:myapp/core/features/report/presentation/widgets/report_pop_up_button.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:myapp/features/chat/presentation/cubit/unread_messages_count_cubit.dart';
import 'package:myapp/features/chat/presentation/message_bloc/bloc/message_bloc.dart';
import 'package:myapp/features/chat/presentation/widgets/donation_message_bubble.dart';
import 'package:myapp/features/chat/presentation/widgets/request_message_bubble.dart';
import 'package:myapp/features/chat/presentation/widgets/text_messages_bubble.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage(
      {super.key,
      required this.chat,
      this.defaultMessage,
      this.messageTypeId,
      this.messageTypeLocation});
  final Chat chat;
  final MessageType? defaultMessage;
  final String? messageTypeId;
  final Location? messageTypeLocation;
  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _controller = TextEditingController();
  Stream<List<Message>>? messagesStream;
  List<Message> messages = [];

  late StreamSubscription<List<Message>> messagesSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageBloc>().add(MessagesOFAChatFetched(widget.chat));
      if (widget.defaultMessage != null &&
          widget.defaultMessage == MessageType.request) {
        sendMessage(MessageType.request);
      }
      if (widget.defaultMessage != null &&
          widget.defaultMessage == MessageType.donation) {
        sendMessage(MessageType.donation);
      }
    });

    //context.read<MessageBloc>().add(MessagesViewedMarked(widget.chat));
    context.read<UnreadMessagesCountCubit>().closeStreamController();
    // print('init');
    // print(widget.otherUser.fcmToken);
  }

  @override
  void dispose() {
    _controller.dispose();
    messagesSubscription.cancel();
    super.dispose();
    // context.read<MessageBloc>().close();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;

    messagesStream = context.watch<MessageBloc>().state;
    // Subscribe to the stream
    messagesSubscription = messagesStream!.listen((event) async {
      context.read<MessageBloc>().add(MessagesViewedMarked(widget.chat));
    });
    return BlocListener<ReportBloc, ReportState>(
      listener: (context, state) {
        if (state is PostAReportSuccess) {
          showSnackBar(
              context, AppLocalizations.of(context)!.msgPage_reportSubmit);
        }
        if (state is PostAReportFailure) {
          showSnackBar(
              context, AppLocalizations.of(context)!.msgPage_submitError);
        }
      },
      child: PopScope(
        onPopInvoked: (didPop) => context
            .read<UnreadMessagesCountCubit>()
            .unreadMessagesCountFetched(),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  foregroundImage: widget.chat.otherUserImageUrl != null
                      ? NetworkImage(widget.chat.otherUserImageUrl!)
                      : null,
                  child: widget.chat.otherUserImageUrl != null
                      ? null
                      : Center(
                          child: Text(
                            widget.chat.otherUserName
                                .substring(0, 1)
                                .toUpperCase(),
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Text(widget.chat.otherUserName),
              ],
            ),
            actions: [
              CustomPopUpButton(
                reportTypeId: widget.chat.chatId,
                reportType: ReportType.chat,
                otherPartyId: widget.chat.otherUserId,
              )
            ],
          ),
          body: Column(
            children: [
              StreamBuilder<List<Message>>(
                stream: messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    messages = snapshot.data!;
                    if (messages.isEmpty) {
                      return Center(
                        child:
                            Text(AppLocalizations.of(context)!.msgPage_sendMsg),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isLastMessage = messages.last == message;
                          final nextMessage = index < messages.length - 1
                              ? messages[index + 1]
                              : null;
                          if (message.messageType == MessageType.text) {
                            if (isLastMessage) {
                              return TextMessagesBubble.isFirst(
                                message: message,
                                currentUser: currentUser,
                              );
                            } else if (nextMessage?.sentBy == message.sentBy) {
                              return TextMessagesBubble.other(
                                message: message,
                                currentUser: currentUser,
                              );
                            } else {
                              return TextMessagesBubble.isFirst(
                                message: message,
                                currentUser: currentUser,
                              );
                            }
                          } else if (message.messageType ==
                              MessageType.request) {
                            if (isLastMessage) {
                              return RequestMessagesBubble.isFirst(
                                message: message,
                                currentUser: currentUser,
                                chat: widget.chat,
                              );
                            } else if (nextMessage?.sentBy == message.sentBy) {
                              return RequestMessagesBubble.other(
                                message: message,
                                currentUser: currentUser,
                                chat: widget.chat,
                              );
                            } else {
                              return RequestMessagesBubble.isFirst(
                                message: message,
                                currentUser: currentUser,
                                chat: widget.chat,
                              );
                            }
                          } else if (message.messageType ==
                              MessageType.donation) {
                            if (isLastMessage) {
                              return DonationMessagesBubble.isFirst(
                                message: message,
                                currentUser: currentUser,
                                chat: widget.chat,
                              );
                            } else if (nextMessage?.sentBy == message.sentBy) {
                              return DonationMessagesBubble.other(
                                message: message,
                                currentUser: currentUser,
                                chat: widget.chat,
                              );
                            } else {
                              return DonationMessagesBubble.isFirst(
                                message: message,
                                currentUser: currentUser,
                                chat: widget.chat,
                              );
                            }
                          }
                          return null;
                        },
                      ),
                    );
                  }
                  return const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.msgPage_typeMsg,
                            contentPadding: const EdgeInsets.all(16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                      child: IconButton(
                        onPressed: () {
                          if (_controller.text == '') {
                            return;
                          }
                          sendMessage(MessageType.text);
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage(
    MessageType messageType,
  ) {
    final currentUser = context.read<UserCubit>().state;
    late Message message;
    if (messageType == MessageType.text) {
      message = Message(
        messageTypeId: null,
        action: false,
        location: null,
        messageType: MessageType.text,
        text: _controller.text,
        image: null,
        sentBy: widget.chat.currentUserId,
        sentTo: widget.chat.otherUserId,
        timeSent: DateTime.now(),
        isViewed: false,
      );
      setState(() {
        _controller.clear();
      });
    }
    if (messageType == MessageType.request) {
      message = Message(
        messageTypeId: widget.messageTypeId,
        action: null,
        location: widget.messageTypeLocation,
        messageType: MessageType.request,
        text:
            "${widget.chat.otherUserName} ${AppLocalizations.of(context)!.msgPage_needHelp}",
        image: null,
        sentBy: widget.chat.currentUserId,
        sentTo: widget.chat.otherUserId,
        timeSent: DateTime.now(),
        isViewed: false,
      );
    }

    if (messageType == MessageType.donation) {
      message = Message(
        messageTypeId: widget.messageTypeId,
        action: null,
        location: widget.messageTypeLocation,
        messageType: MessageType.donation,
        text:
            "${widget.chat.otherUserName} ${AppLocalizations.of(context)!.msgPage_willingHelp}",
        image: null,
        sentBy: widget.chat.currentUserId,
        sentTo: widget.chat.otherUserId,
        timeSent: DateTime.now(),
        isViewed: false,
      );
    }

    context.read<ChatBloc>().add(SentANewMessage(widget.chat, message));
    final AudioPlayer _audioPlayer = AudioPlayer();
    // _audioPlayer
    //     .setSourceAsset('');
    _audioPlayer.play(AssetSource('sounds/mixkit-message-pop-alert-2354.mp3'));
    log(widget.chat.currentUserFcmToken.toString());
    log(widget.chat.otherUserFcmToken.toString());

    if (widget.chat.otherUserFcmToken != null) {
      context.read<NotificationBloc>().add(
            NotificationFromOneDeviceToAnotherSent(widget.chat, message),
          );
    }
  }
}
