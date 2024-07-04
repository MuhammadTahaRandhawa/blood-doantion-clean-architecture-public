part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentState {}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentSubmittedFailure extends AppointmentState {
  final String message;

  AppointmentSubmittedFailure(this.message);
}

final class MyAppointmentFetchedFailure extends AppointmentState {
  final String message;

  MyAppointmentFetchedFailure(this.message);
}

final class UpdateAppointmentStatusAndTimeFailure extends AppointmentState {
  final String message;

  UpdateAppointmentStatusAndTimeFailure(this.message);
}

final class AppointmentSubmittedSuccess extends AppointmentState {}

final class UpdateAppointmentStatusAndTimeSuccess extends AppointmentState {}

final class MyAppointmentFetchedSuccess extends AppointmentState {
  final List<Appointment> appointments;

  MyAppointmentFetchedSuccess(this.appointments);
}

final class MyInvolvedAppointmentFetchedFailure extends AppointmentState {
  final String message;

  MyInvolvedAppointmentFetchedFailure(this.message);
}

final class MyInvolvedAppointmentFetchedSuccess extends AppointmentState {
  final List<Appointment> appointments;

  MyInvolvedAppointmentFetchedSuccess(this.appointments);
}

final class AppointmentIsCompleteUpdatedFailure extends AppointmentState {
  final String message;

  AppointmentIsCompleteUpdatedFailure(this.message);
}

final class AppointmentIsCompleteUpdatedSuccess extends AppointmentState {}

final class AppointmentStatusUpdatedSuccess extends AppointmentState {}

final class AppointmentStatusUpdatedFailure extends AppointmentState {
  final String message;

  AppointmentStatusUpdatedFailure(this.message);
}

final class AppointmentFetchedByIdSuccess extends AppointmentState {
  final Appointment appointment;

  AppointmentFetchedByIdSuccess(this.appointment);
}

final class AppointmentFetchedByIdFailure extends AppointmentState {
  final String message;

  AppointmentFetchedByIdFailure(this.message);
}
