import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';

abstract interface class AppointmentRepository {
  Future<Either<Failure, List<Appointment>>> fetchMyAppointments();
  // Future<Either<Failure, Unit>> submitACenterAppointment(
  //     Appointment appointment);
  Future<Either<Failure, Unit>> updateAppointmentStatus(
      String appointmentId, AppointmentStatus newAppointmentStatus);
  // Future<Either<Failure, Unit>> submitARequestAppointment(
  //     Appointment appointment);
  Future<Either<Failure, Unit>> submitAnAppointment(Appointment appointment);
  Future<Either<Failure, Unit>> updateAppointmentStatusAndTime(
      String appointmentId,
      AppointmentStatus newAppointmentStatus,
      DateTime dateTime);
  Future<Either<Failure, List<Appointment>>> fetchMyInvolvedAppointments();
  Either<Failure, Stream<List<Appointment>>>
      fetchStreamOfMyOverallAppointments();

  Future<Either<Failure, Unit>> updateAppointmentIsCompleted(
      String appointmentId, bool meIsCreater, bool isCompleted);

  Future<Either<Failure, Appointment>> fetchAppointmentById(
      String appointmentId);
}
