import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:myapp/core/features/appointments/data/models/appointment_model.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentRemoteDataSource appointmentRemoteDataSource;

  AppointmentRepositoryImpl(this.appointmentRemoteDataSource);
  @override
  Future<Either<Failure, List<Appointment>>> fetchMyAppointments() async {
    try {
      final res = await appointmentRemoteDataSource.fetchMyAppointments();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitAnAppointment(
      Appointment appointment) async {
    try {
      final res = await appointmentRemoteDataSource
          .submitAnAppointment(AppointmentModel.fromAppointment(appointment));
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAppointmentStatusAndTime(
      String appointmentId,
      AppointmentStatus newAppointmentStatus,
      DateTime dateTime) async {
    try {
      final res =
          await appointmentRemoteDataSource.updateAppointmentStatusAndTime(
              appointmentId, newAppointmentStatus, dateTime);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>>
      fetchMyInvolvedAppointments() async {
    try {
      final res =
          await appointmentRemoteDataSource.fetchMyInvlovedAppointments();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Either<Failure, Stream<List<Appointment>>>
      fetchStreamOfMyOverallAppointments() {
    try {
      return right(
          appointmentRemoteDataSource.fetchStreamOfMyOverallAppointments());
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAppointmentIsCompleted(
      String appointmentId, bool meIsCreater, bool isCompleted) async {
    try {
      return right(
          await appointmentRemoteDataSource.updateAppointmentIsCompleted(
              appointmentId, meIsCreater, isCompleted));
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAppointmentStatus(
      String appointmentId, AppointmentStatus newAppointmentStatus) async {
    try {
      final res = await appointmentRemoteDataSource.updateAppointmentStatus(
        appointmentId,
        newAppointmentStatus,
      );
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Appointment>> fetchAppointmentById(
      String appointmentId) async {
    try {
      final res =
          await appointmentRemoteDataSource.fetchAppointmentById(appointmentId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }
}
