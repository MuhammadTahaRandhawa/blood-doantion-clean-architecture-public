import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/utilis/get_conversation_id.dart';
import 'package:myapp/core/utilis/is_donation_allowed.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/presentation/pages/blood_request_detail_page.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/presentation/pages/messages_page.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodRequestCard extends StatelessWidget {
  const BloodRequestCard({
    super.key,
    required this.request,
    this.isSelecting = false,
  });

  final Request request;
  final bool isSelecting;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: CircleAvatar(
            radius: 40,
            // foregroundImage:
            //    request. != null ? NetworkImage(userImageUrl!) : null,
            child: Center(
              child: Text(request.requesterName.substring(0, 1).toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                request.requesterName,
                style: const TextStyle().copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                request.location.address,
                style: const TextStyle().copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              RequestDetailPage(request: request),
                        ));
                      },
                      child: Text(
                          AppLocalizations.of(context)!.bloodReqCard_view)),
                  FilledButton(
                      onPressed:
                          (currentUser.userId == request.userId && !isSelecting)
                              ? null
                              : () {
                                  isSelecting
                                      ? onPressedSelecting(context)
                                      : onPressedHelp(context, currentUser);
                                },
                      child: Text(isSelecting
                          ? AppLocalizations.of(context)!.bloodReqCard_select
                          : AppLocalizations.of(context)!.bloodReqCard_help))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: CircleAvatar(
            child: Text(request.bloodGroup),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ]),
    );
  }

  void onPressedHelp(BuildContext context, User currentUser) {
    const Uuid uuid = Uuid();
    final String id = uuid.v4();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MessagesPage(
          defaultMessage: MessageType.donation,
          messageTypeId: id,
          messageTypeLocation: currentUser.location,
          chat: Chat(
              currentUserFcmToken: currentUser.fcmToken,
              otherUserFcmToken: request.fcmToken,
              chatId: getconversationIdHash(currentUser.userId, request.userId),
              currentUserId: currentUser.userId,
              otherUserId: request.userId,
              otherUserName: request.requesterName,
              currentUserName: currentUser.userName,
              lastMessage: '',
              currentUserImageUrl: currentUser.userProfileImageUrl,
              otherUserImageUrl: null,
              lastMessageDateTime: DateTime.now(),
              lastMessageSentBy: currentUser.userId)),
    ));

    context.read<AppointmentBloc>().add(AppointmentSubmitted(Appointment(
        participantIsCompleted: null,
        createrIsCompleted: null,
        appointmentStatus: AppointmentStatus.pending,
        appointmentType: AppointmentType.donation,
        bloodGroup: request.bloodGroup,
        appointmentParticipantId: request.userId,
        appointmentCreaterId: currentUser.userId,
        appointmentLocation: request.location,
        appointmentCreaterPhoneNo: currentUser.phoneNo,
        appointmentOtherPartyType: AppointmentOtherParty.user,
        appointmentDateTime: null,
        appointmentCase: request.requestCase,
        bloodBags: request.bloodBags,
        fetchedAppointmentID: id,
        appointmentDateTimeCreated: DateTime.now(),
        appointmentParticipantName: request.requesterName,
        appointmentCreaterName: currentUser.userName)));
  }

  void onPressedSelecting(BuildContext context) {
    Navigator.of(context).pop(request);
  }
}
