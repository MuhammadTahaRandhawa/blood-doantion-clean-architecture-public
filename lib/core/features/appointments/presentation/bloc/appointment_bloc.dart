import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/domain/usecases/fetch_appointment_by_id.dart';
import 'package:myapp/core/features/appointments/domain/usecases/fetch_my_appointments.dart';
import 'package:myapp/core/features/appointments/domain/usecases/fetch_my_involved_appointments.dart';
import 'package:myapp/core/features/appointments/domain/usecases/fetch_stream_of_my_overall_appointments.dart';
import 'package:myapp/core/features/appointments/domain/usecases/submit_an_appointment.dart';
import 'package:myapp/core/features/appointments/domain/usecases/update_appointment_is_completed.dart';
import 'package:myapp/core/features/appointments/domain/usecases/update_appointment_status.dart';
import 'package:myapp/core/features/appointments/domain/usecases/update_appointment_status_and_time.dart';
import 'package:myapp/core/features/appointments/presentation/cubit/appointment_cubit.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final UpdateAppointmentStatusAndTime updateAppointmentStatusAndTime;
  final SubmitAnAppointment submitAnAppointment;
  final FetchMyAppointments fetchMyAppointments;
  final FetchMyInvlovedAppointments fetchMyInvlovedAppointments;
  final AppointmentCubit appointmentCubit;
  final FetchStreamOfMyOverallAppointments fetchStreamOfMyOverallAppointments;
  final UpdateIsAppointmentCompleted updateIsAppointmentCompleted;
  final UpdateAppointmentStatus updateAppointmentStatus;
  final FetchAppointmentsById fetchAppointmentsById;
  late final StreamSubscription<List<Appointment>>? _subscription;
  AppointmentBloc(
      this.updateAppointmentStatusAndTime,
      this.submitAnAppointment,
      this.fetchMyAppointments,
      this.fetchMyInvlovedAppointments,
      this.fetchStreamOfMyOverallAppointments,
      this.appointmentCubit,
      this.updateIsAppointmentCompleted,
      this.updateAppointmentStatus,
      this.fetchAppointmentsById)
      : super(AppointmentInitial()) {
    on((event, emit) => emit(AppointmentLoading()));
    on<MyAppointmentsFetched>((event, emit) async {
      final res = await fetchMyAppointments.call(unit);
      res.fold((l) => emit(MyAppointmentFetchedFailure(l.message)),
          (r) => emit(MyAppointmentFetchedSuccess(r)));
    });
    on<AppointmentSubmitted>((event, emit) async {
      final res = await submitAnAppointment.call(event.appointment);
      res.fold((l) => emit(AppointmentSubmittedFailure(l.message)),
          (r) => emit(AppointmentSubmittedSuccess()));
    });
    on<AppointmentDateAndTimeUpdated>((event, emit) async {
      final res = await updateAppointmentStatusAndTime.call(
          UpdateAppointmentStatusAndTimeParams(event.appointmentId,
              event.appointmentStatus, event.updatedDateTime));
      res.fold((l) => emit(UpdateAppointmentStatusAndTimeFailure(l.message)),
          (r) => emit(UpdateAppointmentStatusAndTimeSuccess()));
    });

    on<MyInvolvedAppointmentsFetched>((event, emit) async {
      final res = await fetchMyInvlovedAppointments.call(unit);
      res.fold((l) => emit(MyInvolvedAppointmentFetchedFailure(l.message)),
          (r) => emit(MyInvolvedAppointmentFetchedSuccess(r)));
    });

    on<StreamOfMyOverAllAppointmentsFetched>((event, emit) {
      final res = fetchStreamOfMyOverallAppointments.call(unit);
      res.fold((l) => null, (r) {
        _subscription = r.listen((List<Appointment> appointments) {
          log('inside bloc $appointments');
          appointmentCubit.initializeAppointments(appointments);
        });
      });
    });
    on<AppointmentIsCompleteUpdated>((event, emit) async {
      final res = await updateIsAppointmentCompleted.call(
          UpdateIsAppointmentCompletedParams(
              event.appointmentId, event.meIsCreater, event.isCompleted));
      res.fold((l) => emit(AppointmentIsCompleteUpdatedFailure(l.message)),
          (r) => emit(AppointmentIsCompleteUpdatedSuccess()));
    });
    on<AppointmentStatusUpdated>((event, emit) async {
      final res = await updateAppointmentStatus.call(
          UpdateAppointmentStatusParams(
              event.appointmentId, event.newAppointmentStatus));
      res.fold((l) => emit(AppointmentStatusUpdatedFailure(l.message)),
          (r) => emit(AppointmentStatusUpdatedSuccess()));
    });

    on<AppointmentFetchedById>((event, emit) async {
      final res = await fetchAppointmentsById.call(event.appointmentId);
      res.fold((l) => emit(AppointmentFetchedByIdFailure(l.message)),
          (r) => emit(AppointmentFetchedByIdSuccess(r)));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
