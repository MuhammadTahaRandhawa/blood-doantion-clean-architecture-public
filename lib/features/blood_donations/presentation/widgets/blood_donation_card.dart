import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/utilis/get_conversation_id.dart';
import 'package:myapp/core/utilis/is_donation_allowed.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/presentation/pages/blood_donation_detail_page.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/presentation/pages/my_blood_requests_page.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/presentation/pages/messages_page.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodDonationCard extends StatelessWidget {
  const BloodDonationCard({super.key, required this.donation});

  final Donation donation;
  final Uuid uuid = const Uuid();

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
            //    request. userImageUrl != null ? NetworkImage(userImageUrl!) : null,
            child: donation.userProfileImageUrl == null
                ? Text(donation.userName.substring(0, 1).toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium)
                : SizedBox(
                    width: 80, // Set the desired width (adjust as needed)
                    height: 70, // Set the desired height (adjust as needed)
                    child: ClipOval(
                      child: Image.network(
                        donation.userProfileImageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Image is fully loaded, show the actual image
                            return child;
                          } else {
                            // Show a loading indicator (you can customize this widget)
                            return CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            );
                          }
                        },
                      ),
                    ),
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
                donation.userName,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                donation.location.address,
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
                              DonationDetailPage(donation: donation),
                        ));
                      },
                      child: Text(AppLocalizations.of(context)!
                          .bloodDonationcard_view)),
                  FilledButton(
                      onPressed: currentUser.userId == donation.userId
                          ? null
                          : () async {
                              final Request? res = await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (context) => const MyBloodRequestsPage(
                                  isSelecting: true,
                                ),
                              ));
                              if (res != null) {
                                if (isDonationAllowed(
                                    donation.bloodGroup, res.bloodGroup)) {
                                  gotoMessagePage(context, res, currentUser);
                                } else {
                                  showSnackBar(context,
                                      "${donation.bloodGroup} can't be donated to ${res.bloodGroup}");
                                }
                              }
                            },
                      child: Text(AppLocalizations.of(context)!
                          .bloodDonationcard_AskHelp))
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
            child: Text(donation.bloodGroup),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ]),
    );
  }

  void gotoMessagePage(
      BuildContext context, Request request, User currentUser) {
    final String id = uuid.v4();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MessagesPage(
          messageTypeId: id,
          defaultMessage: MessageType.request,
          messageTypeLocation: request.location,
          chat: Chat(
              chatId:
                  getconversationIdHash(currentUser.userId, donation.userId),
              currentUserId: currentUser.userId,
              otherUserId: donation.userId,
              otherUserName: donation.userName,
              currentUserName: currentUser.userName,
              lastMessage: '',
              currentUserImageUrl: currentUser.userProfileImageUrl,
              otherUserImageUrl: donation.userProfileImageUrl,
              lastMessageDateTime: DateTime.now(),
              lastMessageSentBy: currentUser.userId,
              currentUserFcmToken: currentUser.fcmToken,
              otherUserFcmToken: donation.fcmToken)),
    ));
    context.read<AppointmentBloc>().add(AppointmentSubmitted(Appointment(
        participantIsCompleted: null,
        createrIsCompleted: null,
        appointmentStatus: AppointmentStatus.pending,
        appointmentType: AppointmentType.request,
        bloodGroup: request.bloodGroup,
        appointmentParticipantId: donation.userId,
        appointmentCreaterId: currentUser.userId,
        appointmentLocation: request.location,
        appointmentCreaterPhoneNo: currentUser.phoneNo,
        appointmentOtherPartyType: AppointmentOtherParty.user,
        appointmentDateTime: null,
        appointmentCase: request.requestCase,
        bloodBags: request.bloodBags,
        fetchedAppointmentID: id,
        appointmentDateTimeCreated: DateTime.now(),
        appointmentParticipantName: donation.userName,
        appointmentCreaterName: currentUser.userName)));
  }
}
