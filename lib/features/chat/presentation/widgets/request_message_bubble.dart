import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/features/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:myapp/core/features/appointments/presentation/pages/appointment_detail_page.dart';
import 'package:myapp/core/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:myapp/core/features/notifications/domain/entities/notification_data.dart';
import 'package:myapp/core/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_requests/presentation/bloc/blood_request_bloc.dart';
import 'package:myapp/features/blood_requests/presentation/pages/blood_request_detail_page.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:myapp/features/chat/presentation/helpers/chat_helpers.dart';

class RequestMessagesBubble extends StatefulWidget {
  final Message message;
  final User currentUser;
  final bool isFirst;
  final Chat chat;

  const RequestMessagesBubble.isFirst(
      {super.key,
      required this.message,
      required this.currentUser,
      required this.chat})
      : isFirst = true;
  const RequestMessagesBubble.other(
      {super.key,
      required this.message,
      required this.currentUser,
      required this.chat})
      : isFirst = false;

  @override
  State<RequestMessagesBubble> createState() => _RequestMessagesBubbleState();
}

class _RequestMessagesBubbleState extends State<RequestMessagesBubble> {
  Image? mapsImage;
  @override
  void initState() {
    log(widget.message.location.toString());
    context.read<MapsBloc>().add(MapsStaticImageFetched(LatitudeLongitude(
        latitude: widget.message.location!.latitude,
        longitude: widget.message.location!.longitude)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<MapsBloc, MapsState>(listener: (context, state) {
            if (state is MapsStaticImageSuccess) {
              setState(() {
                mapsImage = state.image;
              });
            }
          }),
          BlocListener<AppointmentBloc, AppointmentState>(
            listener: (context, state) {
              if (state is AppointmentFetchedByIdSuccess) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AppointmentDetailPage(appointment: state.appointment),
                ));
              }
              if (state is AppointmentFetchedByIdFailure) {
                showSnackBar(context, state.message);
              }
            },
          ),
        ],
        child: widget.message.sentBy == widget.currentUser.userId
            ? _buildSenderBubble(context)
            : _buildReceiverBubble(context));
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
            topRight: widget.isFirst ? Radius.zero : const Radius.circular(20),
            topLeft: const Radius.circular(20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.donMsgBubble_askHelp),
            const SizedBox(
              height: 10,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: mapsImage ??
                  Center(
                    child: Text(
                        AppLocalizations.of(context)!.donMsgBubble_imgError),
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(widget.message.location!.address),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () {
                      context.read<AppointmentBloc>().add(
                          AppointmentFetchedById(
                              widget.message.messageTypeId!));
                    },
                    child: Text(
                        AppLocalizations.of(context)!.donMsgBubble_viewBtn)),
                FilledButton(
                    onPressed:
                        widget.message.sentBy == widget.currentUser.userId
                            ? null
                            : () {},
                    child: Text(
                        AppLocalizations.of(context)!.donMsgBubble_helpBtn)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    ChatHelpers.convertChatDateTimeToString(
                        widget.message.timeSent),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  widget.message.isViewed
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
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: widget.isFirst ? Radius.zero : const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.message.text}'),
            const SizedBox(
              height: 10,
            ),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: mapsImage ??
                  Center(
                    child: Text(
                        AppLocalizations.of(context)!.donMsgBubble_imgError),
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(widget.message.location!.address),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () {
                      context.read<AppointmentBloc>().add(
                          AppointmentFetchedById(
                              widget.message.messageTypeId!));
                    },
                    child: Text(
                        AppLocalizations.of(context)!.donMsgBubble_viewBtn)),
                FilledButton(
                    onPressed: (widget.message.sentBy ==
                                widget.currentUser.userId ||
                            widget.message.action != null)
                        ? null
                        : () async {
                            TimeOfDay timeOfDay = TimeOfDay.now();
                            final pickedTime = await showTimePicker(
                                context: context, initialTime: timeOfDay);
                            if (pickedTime != null) {
                              timeOfDay = pickedTime;
                            }

                            final DateTime now = DateTime.now();
                            final appointmentTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                timeOfDay.hour,
                                timeOfDay.minute);
                            context.read<AppointmentBloc>().add(
                                AppointmentDateAndTimeUpdated(
                                    widget.message.messageTypeId!,
                                    AppointmentStatus.approved,
                                    appointmentTime));
                            context.read<ChatBloc>().add(SendApprovedMessage(
                                widget.chat, widget.message));
                            context
                                .read<AppointmentCubit>()
                                .updateAnAppointment(
                                    widget.message.messageTypeId!,
                                    AppointmentStatus.approved,
                                    appointmentTime);
                            context.read<NotificationBloc>().add(
                                NotificationFromOneDeviceToAnotherSent(
                                    Chat(
                                        chatId: widget.chat.chatId,
                                        currentUserId:
                                            widget.currentUser.userId,
                                        otherUserId: widget.message.sentBy,
                                        otherUserName:
                                            widget.chat.otherUserName,
                                        currentUserName:
                                            widget.currentUser.userName,
                                        lastMessage: widget.chat.lastMessage,
                                        currentUserImageUrl: widget
                                            .currentUser.userProfileImageUrl,
                                        otherUserImageUrl:
                                            widget.chat.otherUserImageUrl,
                                        lastMessageDateTime:
                                            widget.chat.lastMessageDateTime,
                                        lastMessageSentBy:
                                            widget.currentUser.userId,
                                        currentUserFcmToken:
                                            widget.currentUser.fcmToken,
                                        otherUserFcmToken:
                                            widget.chat.otherUserFcmToken),
                                    Message(
                                        messageTypeId:
                                            widget.currentUser.userId,
                                        action: true,
                                        location: widget.currentUser.location,
                                        messageType: MessageType.donation,
                                        text: '',
                                        image: null,
                                        sentBy: widget.currentUser.userId,
                                        sentTo: widget.chat.otherUserId,
                                        timeSent: DateTime.now(),
                                        isViewed: true)));
                            context.read<NotificationBloc>().add(
                                ScheduledNotificationSent(
                                    NotificationData(
                                        notificationTitle:
                                            AppLocalizations.of(context)!
                                                .donMsgBubble_reminder,
                                        notificationBody:
                                            '${AppLocalizations.of(context)!.donMsgBubble_haveAppointment} ${widget.currentUser.userName}',
                                        senderName: widget.currentUser.userName,
                                        senderId: widget.currentUser.userId,
                                        senderFcmToken:
                                            widget.currentUser.fcmToken ?? '',
                                        receiverId: widget.message.sentBy,
                                        receiverFcmToken:
                                            widget.chat.otherUserFcmToken ?? '',
                                        notificationType:
                                            NotificationType.appointment),
                                    appointmentTime));
                          },
                    child: Text(
                        AppLocalizations.of(context)!.donMsgBubble_helpBtn)),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    ChatHelpers.convertChatDateTimeToString(
                        widget.message.timeSent),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
