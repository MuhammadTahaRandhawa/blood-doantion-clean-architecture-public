import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';

class AppointmentCubit extends Cubit<List<Appointment>> {
  AppointmentCubit() : super([]);

  void initializeAppointments(List<Appointment> appointments) {
    emit(appointments);
  }

  void clear() {
    emit([]);
  }

  void addListOfAppointments(List<Appointment> appointments) {
    emit([...state, ...appointments]);
  }

  List<Appointment> getValidAppointments(
      List<Appointment> inputAppointments, User currentUser) {
    final updatedAppointments = inputAppointments
        .where((element) =>
            (element.appointmentCreaterId == currentUser.userId ||
                (element.appointmentParticipantId == currentUser.userId &&
                    element.appointmentStatus != AppointmentStatus.pending)))
        .sortWithDate((instance) => instance.appointmentDateTimeCreated)
        .toList();

    return updatedAppointments;
  }

  List<Appointment> getTodayAppointments(List<Appointment> appointments) {
    final today = DateTime.now();
    final updatedappointments = appointments
        .where((element) => element.appointmentDateTimeCreated.day == today.day)
        .toList();
    return updatedappointments;
  }

  List<Appointment> getPendingAppointments(List<Appointment> appointments) {
    return appointments
        .where(
            (element) => element.appointmentStatus == AppointmentStatus.pending)
        .toList();
  }

  List<Appointment> getApprovedAppointments(List<Appointment> appointments) {
    return appointments
        .where((element) =>
            element.appointmentStatus == AppointmentStatus.approved)
        .toList();
  }

  List<Appointment> getInProgressAppointments(List<Appointment> appointments) {
    return appointments
        .where((element) =>
            element.appointmentStatus == AppointmentStatus.inProgress)
        .toList();
  }

  List<Appointment> getCompletedAppointments(List<Appointment> appointments) {
    return appointments
        .where((element) =>
            element.appointmentStatus == AppointmentStatus.completed)
        .toList();
  }

  List<Appointment> getCancelledAppointments(List<Appointment> appointments) {
    return appointments
        .where((element) =>
            element.appointmentStatus == AppointmentStatus.cancelled)
        .toList();
  }

  void updateAnAppointment(String appointmentId,
      AppointmentStatus appointmentStatus, DateTime updatedDateTime) {
    final updatedAppointments = state
        .map((e) => e.appointmentID == appointmentId
            ? Appointment(
                participantIsCompleted: e.participantIsCompleted,
                createrIsCompleted: e.createrIsCompleted,
                appointmentDateTimeCreated: e.appointmentDateTimeCreated,
                appointmentStatus: appointmentStatus,
                appointmentType: e.appointmentType,
                bloodGroup: e.bloodGroup,
                appointmentParticipantId: e.appointmentParticipantId,
                appointmentCreaterId: e.appointmentCreaterId,
                appointmentLocation: e.appointmentLocation,
                appointmentCreaterPhoneNo: e.appointmentCreaterPhoneNo,
                appointmentOtherPartyType: e.appointmentOtherPartyType,
                appointmentDateTime: updatedDateTime,
                appointmentParticipantName: e.appointmentParticipantName,
                appointmentCase: e.appointmentCase,
                bloodBags: e.bloodBags,
                fetchedAppointmentID: e.appointmentID,
                appointmentCreaterName: e.appointmentCreaterName)
            : e)
        .toList();

    emit(updatedAppointments);
  }

  List<Appointment> appointmentsToFetchIsCompletedEvent(
      List<Appointment> appointments, User currentUser) {
    return appointments
        .where((appointment) => ((appointment.appointmentStatus !=
                    AppointmentStatus.pending &&
                appointment.appointmentStatus != AppointmentStatus.completed) &&
            (appointment.appointmentCreaterId == currentUser.userId
                ? appointment.createrIsCompleted == null
                : appointment.participantIsCompleted == null)))
        .toList();
  }
}
