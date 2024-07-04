import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:myapp/core/features/appointments/presentation/widgets/blood_appointment_card.dart';
import 'package:myapp/core/features/appointments/presentation/widgets/toogle_appointment_status_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final myAppointments = context.watch<AppointmentCubit>().state;
    final currentUser = context.watch<UserCubit>().state;
    List<Appointment> validAppointments = context
        .read<AppointmentCubit>()
        .getValidAppointments(myAppointments, currentUser);
    final tabAppointments = getAppointments(validAppointments);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myappointment_appBar),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            ToggleAppointmentStatusButtons(
              selectedTabIndex: index,
              onChangeTab: _onChangeTab,
            ),
            if (tabAppointments.isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          kIsWeb
                              ? 'images/searching_did_not_find.png'
                              : 'assets/images/searching_did_not_find.png',
                          height: 200,
                          alignment: Alignment.center,
                        ),
                        Text(
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                            textAlign: TextAlign.center,
                            AppLocalizations.of(context)!
                                .appointments_page_noAppointment),
                      ],
                    ),
                  ),
                ),
              ),
            if (tabAppointments.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) =>
                      BloodAppointmentCard(appointment: tabAppointments[index]),
                  itemCount: tabAppointments.length,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Appointment> getAppointments(List<Appointment> appointments) {
    switch (index) {
      case 0:
        return context
            .read<AppointmentCubit>()
            .getPendingAppointments(appointments);
      case 1:
        return context
            .read<AppointmentCubit>()
            .getApprovedAppointments(appointments);
      case 2:
        return context
            .read<AppointmentCubit>()
            .getInProgressAppointments(appointments);
      case 3:
        return context
            .read<AppointmentCubit>()
            .getCompletedAppointments(appointments);
      case 4:
        return context
            .read<AppointmentCubit>()
            .getCancelledAppointments(appointments);
      default:
        throw ArgumentError();
    }
  }

  _onChangeTab(int value) {
    setState(() {
      index = value;
    });
  }
}
