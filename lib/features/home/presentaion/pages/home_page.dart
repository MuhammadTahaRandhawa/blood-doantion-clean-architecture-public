import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/bloc/user_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/features/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:myapp/core/features/appointments/presentation/widgets/my_appointmets_home_widget.dart';
import 'package:myapp/core/features/drawer/app_drawer.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/features/location/presentation/bloc/location_bloc.dart';
import 'package:myapp/core/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/chat/presentation/cubit/unread_messages_count_cubit.dart';
import 'package:myapp/features/home/presentaion/widgets/home_appbar.dart';
import 'package:myapp/features/home/presentaion/widgets/home_top_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  int unreadMessages = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    context.read<NotificationBloc>().add(NotificationsPermissionRequested());
    context.read<UnreadMessagesCountCubit>().unreadMessagesCountFetched();
    context.read<LocationBloc>().add(LocationFetched());
    context.read<AppointmentCubit>().clear();
    context.read<AppointmentBloc>().add(StreamOfMyOverAllAppointmentsFetched());
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _stopAnimation() {
    _animationController.stop();
  }

  // int _appointmentsFetched = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final user = context.watch<UserCubit>().state;

    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLocationUpdatedFailure) {
              showSnackBar(context, 'Unable to Update Location to Server!');
            }
          },
        ),
        BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationPermissionFailure) {
              showSnackBar(context, state.message);
            }
            if (state is LocationFailure) {
              showSnackBar(context, state.message);
            }
            if (state is LocationSuccess) {
              final location = state.successData as Location;
              context.read<UserCubit>().updateUserLocation(location);
              context.read<UserBloc>().add(UserLocationUpdated(location));
            }
          },
        ),
        BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state is NotificationPermissionSuccess) {
              context
                  .read<NotificationBloc>()
                  .add(NotificationDeviceFcmTokenRequested());
              context
                  .read<NotificationBloc>()
                  .add(FirebaseMessagingInitialized(user, context));

              context
                  .read<NotificationBloc>()
                  .add(SetupInteractedMessage(context));
            }
            if (state is GetFcmTokenSuccess) {
              log('NotificationTokenGot');
              context.read<UserBloc>().add(UserFcmTokenUpdated(state.fcmToken));
            }
          },
        ),
        // BlocListener<AppointmentBloc, AppointmentState>(
        //   listener: (context, state) {
        //     if (state is MyAppointmentFetchedSuccess) {
        //       log('MyAppointmentFetchedSuccess${state.appointments.length}');
        //       context
        //           .read<AppointmentCubit>()
        //           .addListOfAppointments(state.appointments);
        //       _appointmentsFetched++;
        //     }
        //     if (state is MyInvolvedAppointmentFetchedSuccess) {
        //       log('MyInvolvedAppointmentFetchedSuccess${state.appointments.length}');
        //       context
        //           .read<AppointmentCubit>()
        //           .addListOfAppointments(state.appointments);
        //       _appointmentsFetched++;
        //     }
        //     if (_appointmentsFetched == 2) {
        //       _stopAnimation();
        //     }
        //   },
        // )
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Scaffold(
              drawer: const AppDrawer(),
              appBar: homeAppBar,
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const HomeTopWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 300,
                        child: MyAppointmentsHomeWidget(
                          animationController: _animationController,
                        ),
                      )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
