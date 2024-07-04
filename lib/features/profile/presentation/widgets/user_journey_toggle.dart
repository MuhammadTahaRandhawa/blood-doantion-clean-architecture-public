import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:myapp/core/utilis/date_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserJourneyToggle extends StatefulWidget {
  const UserJourneyToggle({super.key, required this.user});

  final User user;

  @override
  State<UserJourneyToggle> createState() => _UserJourneyToggleState();
}

class _UserJourneyToggleState extends State<UserJourneyToggle> {
  List<Map<String, dynamic>>? data;
  int step = 0;
  @override
  void initState() {
    final List<Appointment> appointments =
        context.read<AppointmentCubit>().state;

    final validAppointments = context
        .read<AppointmentCubit>()
        .getValidAppointments(appointments, widget.user);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      data = validAppointments
          .map((e) => buildStepContent(e, widget.user))
          .toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return data != null
        ? Stepper(
            steps: [
              ...data!.map((e) => Step(
                  title: Text(DateFormatter.convertChatDateTimeToString(
                      e[AppLocalizations.of(context)!.userJourney_appDate])),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e[AppLocalizations.of(context)!
                          .userJourney_participantName]),
                      CircleAvatar(
                        child: Text(e[
                            AppLocalizations.of(context)!.userJourney_bGroup]),
                      )
                    ],
                  ),
                  subtitle: Text(
                      e[AppLocalizations.of(context)!.userJourney_appType] ==
                              AppointmentType.donation
                          ? AppLocalizations.of(context)!
                              .userJourney_youDonateBlood
                          : AppLocalizations.of(context)!
                              .userJourney_requestfrom)))
            ],
            stepIconBuilder: (stepIndex, stepState) => Text(data![stepIndex]
                        [AppLocalizations.of(context)!.userJourney_appType] ==
                    AppointmentType.donation
                ? 'D'
                : 'R'),
            currentStep: step,
            onStepTapped: (value) {
              setState(() {
                step = value;
              });
            },
            onStepContinue: () {
              if (data!.length - 1 != step) {
                setState(() {
                  step++;
                });
              }
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Map<String, dynamic> buildStepContent(
      Appointment appointment, User currentUser) {
    late bool isMine;
    if (appointment.appointmentCreaterId == currentUser.userId) {
      isMine = true;
    } else {
      isMine = false;
    }

    if (isMine) {
      return {
        AppLocalizations.of(context)!.userJourney_appDate:
            appointment.appointmentDateTimeCreated,
        AppLocalizations.of(context)!.userJourney_appType:
            appointment.appointmentType,
        AppLocalizations.of(context)!.userJourney_participantName:
            appointment.appointmentParticipantName,
        AppLocalizations.of(context)!.userJourney_bGroup:
            appointment.bloodGroup,
      };
    } else {
      return {
        AppLocalizations.of(context)!.userJourney_appDate:
            appointment.appointmentDateTimeCreated,
        AppLocalizations.of(context)!.userJourney_appType:
            getOppositeAppointmentType(appointment.appointmentType),
        AppLocalizations.of(context)!.userJourney_participantName:
            appointment.appointmentCreaterName,
        AppLocalizations.of(context)!.userJourney_bGroup:
            appointment.bloodGroup,
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
