import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/pages/appointment_detail_page.dart';
import 'package:myapp/core/utilis/date_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodAppointmentCard extends StatefulWidget {
  const BloodAppointmentCard({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  State<BloodAppointmentCard> createState() => _BloodAppointmentCardState();
}

class _BloodAppointmentCardState extends State<BloodAppointmentCard> {
  late bool isMine;
  late User currentUser;
  User? otherUser;
  bool isLoading = true;
  late Map<String, dynamic> formattedData;

  @override
  void initState() {
    currentUser = context.read<UserCubit>().state;
    isMine = widget.appointment.appointmentCreaterId == currentUser.userId;
    formattedData = getFormattedData(widget.appointment, currentUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.appointment.appointmentDateTime.toString());
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        formattedData['userName'],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.appointment.appointmentLocation.address,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                CircleAvatar(
                  child: Text(widget.appointment.bloodGroup),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(formattedData['appointmentType'] ==
                          AppointmentType.donation
                      ? 'Donation'
                      : 'Request'),
                ),
                if (widget.appointment.appointmentDateTime != null)
                  Text(
                    DateFormatter.convertChatDateTimeToString(
                        widget.appointment.appointmentDateTime!),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        AppointmentDetailPage(appointment: widget.appointment),
                  ));
                },
                child: Text(
                    AppLocalizations.of(context)!.bloodAppointCard_viewDetail),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> getFormattedData(
      Appointment appointment, User currentUser) {
    if (isMine) {
      return {
        'appointmentType': appointment.appointmentType,
        'userName': appointment.appointmentParticipantName,
      };
    } else {
      return {
        'appointmentType':
            getOppositeAppointmentType(appointment.appointmentType),
        'userName': appointment.appointmentCreaterName,
      };
    }
  }

  AppointmentType getOppositeAppointmentType(AppointmentType appointmentType) {
    switch (appointmentType) {
      case AppointmentType.donation:
        return AppointmentType.request;
      case AppointmentType.request:
        return AppointmentType.donation;
      default:
        throw ArgumentError();
    }
  }
}
