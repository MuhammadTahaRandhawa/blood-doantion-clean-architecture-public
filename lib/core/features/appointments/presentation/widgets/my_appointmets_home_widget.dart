import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/features/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:myapp/core/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:myapp/core/features/appointments/presentation/widgets/blood_appointment_card.dart';
import 'package:myapp/core/utilis/spinning_hour_glass.dart';
import 'package:myapp/features/profile/presentation/pages/certificate_page.dart';

class MyAppointmentsHomeWidget extends StatelessWidget {
  const MyAppointmentsHomeWidget({
    super.key,
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final overallAppointments = context.watch<AppointmentCubit>().state;
    log('overall $overallAppointments');
    final currentUser = context.watch<UserCubit>().state;
    List<Appointment> todayAppointments = context
        .read<AppointmentCubit>()
        .getTodayAppointments(context
            .read<AppointmentCubit>()
            .getValidAppointments(overallAppointments, currentUser));
    List<Appointment> showEventsAppointments = context
        .read<AppointmentCubit>()
        .appointmentsToFetchIsCompletedEvent(overallAppointments, currentUser);
    final DateTime now = DateTime.now();
    for (var appointment in showEventsAppointments) {
      final appointmentTime = appointment.appointmentDateTime;
      final durationUntilAppointment = appointmentTime?.difference(now);

      if (durationUntilAppointment != null &&
          durationUntilAppointment.isNegative) {
        _showBloodDonationIsCompletedDialog(context, appointment, currentUser);
      } else {
        if (durationUntilAppointment != null) {
          Timer(durationUntilAppointment, () {
            _showBloodDonationIsCompletedDialog(
                context, appointment, currentUser);
          });
        }
      }
    }
    if (overallAppointments.isNotEmpty) {
      animationController.stop();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.myAppointmentHome_myApp,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyAppointmentsPage(),
                  ));
                },
                child: Text(AppLocalizations.of(context)!
                    .myAppointmentHome_viewMoreBtn)),
          ],
        ),
        todayAppointments.isEmpty
            ? Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitPouringHourGlassRefined(
                        color: Colors.red,
                        size: 100,
                        controller: animationController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (!animationController.isAnimating)
                        Text(
                          AppLocalizations.of(context)!
                              .myAppointmentHome_noApponitment,
                          style: const TextStyle().copyWith(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        )
                    ],
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => BloodAppointmentCard(
                      appointment: todayAppointments[index]),
                  itemCount: todayAppointments.length,
                ),
              )
      ],
    );
  }

  void _showBloodDonationIsCompletedDialog(
      BuildContext context, Appointment appointment, User currentUser) {
    final data = getData(appointment, currentUser, context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Text(
                    data['bloodGroup'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  data['dialogTitle'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['dialogContent'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        data['appointmentAddress'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: data['onPressedNo'],
                child: Text(
                  AppLocalizations.of(context)!.myAppointmentHome_no,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: data['onPressedYes'],
                child: Text(
                  AppLocalizations.of(context)!.myAppointmentHome_yes,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Map<String, dynamic> getData(
      Appointment appointment, User currentUser, BuildContext context) {
    if (appointment.appointmentCreaterId == currentUser.userId) {
      return {
        'dialogTitle': 'Feedback',
        'dialogContent': appointment.appointmentType == AppointmentType.donation
            ? '${AppLocalizations.of(context)!.myAppointmentHome_haveDonate} ${appointment.appointmentParticipantName} ?'
            : '${AppLocalizations.of(context)!.myAppointmentHome_received} ${appointment.appointmentParticipantName} ?',
        'bloodGroup': appointment.bloodGroup,
        'appointmentAddress': appointment.appointmentLocation.address,
        'onPressedNo': () {
          context.read<AppointmentBloc>().add(AppointmentIsCompleteUpdated(
              appointment.appointmentID, true, false));
          _markCompleted(context, appointment);
          Navigator.of(context).pop();
        },
        'onPressedYes': () {
          context.read<AppointmentBloc>().add(AppointmentIsCompleteUpdated(
              appointment.appointmentID, true, true));
          _markCompleted(context, appointment);

          Navigator.of(context).pop();

          if (appointment.appointmentType == AppointmentType.donation) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CertificatePage(),
            ));
          }
        },
      };
    } else {
      return {
        'dialogTitle': 'Feedback',
        'dialogContent': appointment.appointmentType == AppointmentType.donation
            ? '${AppLocalizations.of(context)!.myAppointmentHome_received} ${appointment.appointmentCreaterName} ?'
            : '${AppLocalizations.of(context)!.myAppointmentHome_haveDonate} ${appointment.appointmentCreaterName} ?',
        'bloodGroup': appointment.bloodGroup,
        'appointmentAddress': appointment.appointmentLocation.address,
        'onPressedNo': () {
          context.read<AppointmentBloc>().add(AppointmentIsCompleteUpdated(
              appointment.appointmentID, false, false));
          Navigator.of(context).pop();
        },
        'onPressedYes': () {
          context.read<AppointmentBloc>().add(AppointmentIsCompleteUpdated(
              appointment.appointmentID, false, true));

          Navigator.of(context).pop();
          if (appointment.appointmentType == AppointmentType.request) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CertificatePage(),
            ));
          }
        },
      };
    }
  }

  void _markCompleted(BuildContext context, Appointment appointment) {
    context.read<AppointmentBloc>().add(AppointmentStatusUpdated(
        appointment.appointmentID, AppointmentStatus.completed));
  }
}
