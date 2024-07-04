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
import 'package:myapp/core/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:myapp/features/chat/presentation/helpers/chat_helpers.dart';

class DonationMessagesBubble extends StatefulWidget {
  final Message message;
  final User currentUser;
  final bool isFirst;
  final Chat chat;

  const DonationMessagesBubble.isFirst(
      {super.key,
      required this.message,
      required this.currentUser,
      required this.chat})
      : isFirst = true;
  const DonationMessagesBubble.other(
      {super.key,
      required this.message,
      required this.currentUser,
      required this.chat})
      : isFirst = false;

  @override
  State<DonationMessagesBubble> createState() => _DonationMessagesBubbleState();
}

class _DonationMessagesBubbleState extends State<DonationMessagesBubble> {
  Image? mapsImage;
  @override
  void initState() {
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
            mapsImage = state.image;
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
          ? _buildSenderBubble()
          : _buildReceiverBubble(),
    );
  }

  Widget _buildSenderBubble() {
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
            const Text('you sends donation'),
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
                    child: Text(AppLocalizations.of(context)!
                        .donMsgBubble_acceptDonation)),
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

  Widget _buildReceiverBubble() {
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
            Text(
                '${widget.chat.otherUserName} ${AppLocalizations.of(context)!.donMsgBubble_wantHelp}'),
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
                            context.read<AppointmentBloc>().add(
                                AppointmentDateAndTimeUpdated(
                                    widget.message.messageTypeId!,
                                    AppointmentStatus.approved,
                                    DateTime(now.year, now.month, now.day,
                                        timeOfDay.hour, timeOfDay.minute)));
                            context.read<ChatBloc>().add(SendApprovedMessage(
                                widget.chat, widget.message));
                            context
                                .read<AppointmentCubit>()
                                .updateAnAppointment(
                                    widget.message.messageTypeId!,
                                    AppointmentStatus.approved,
                                    DateTime(now.year, now.month, now.day,
                                        timeOfDay.hour, timeOfDay.minute));
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
                                        messageType: MessageType.request,
                                        text: '',
                                        image: null,
                                        sentBy: widget.currentUser.userId,
                                        sentTo: widget.chat.otherUserId,
                                        timeSent: DateTime.now(),
                                        isViewed: true)));
                          },
                    child: Text(AppLocalizations.of(context)!
                        .donMsgBubble_acceptDonation)),
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
