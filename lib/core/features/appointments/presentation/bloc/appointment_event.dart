part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentEvent {}

class MyAppointmentsFetched extends AppointmentEvent {}

class AppointmentSubmitted extends AppointmentEvent {
  final Appointment appointment;

  AppointmentSubmitted(this.appointment);
}

class AppointmentDateAndTimeUpdated extends AppointmentEvent {
  final String appointmentId;
  final AppointmentStatus appointmentStatus;
  final DateTime updatedDateTime;

  AppointmentDateAndTimeUpdated(
      this.appointmentId, this.appointmentStatus, this.updatedDateTime);
}

class MyInvolvedAppointmentsFetched extends AppointmentEvent {}

class StreamOfMyOverAllAppointmentsFetched extends AppointmentEvent {}

class AppointmentIsCompleteUpdated extends AppointmentEvent {
  final String appointmentId;
  final bool meIsCreater;
  final bool isCompleted;

  AppointmentIsCompleteUpdated(
      this.appointmentId, this.meIsCreater, this.isCompleted);
}

class AppointmentStatusUpdated extends AppointmentEvent {
  final String appointmentId;
  final AppointmentStatus newAppointmentStatus;

  AppointmentStatusUpdated(this.appointmentId, this.newAppointmentStatus);
}

class AppointmentFetchedById extends AppointmentEvent {
  final String appointmentId;

  AppointmentFetchedById(this.appointmentId);
}
