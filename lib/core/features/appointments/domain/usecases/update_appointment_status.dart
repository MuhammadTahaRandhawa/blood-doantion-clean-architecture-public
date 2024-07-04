import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class UpdateAppointmentStatus
    implements Usecase<Unit, UpdateAppointmentStatusParams> {
  final AppointmentRepository appointmentRepository;

  UpdateAppointmentStatus(this.appointmentRepository);
  @override
  Future<Either<Failure, Unit>> call(
      UpdateAppointmentStatusParams params) async {
    return await appointmentRepository.updateAppointmentStatus(
        params.appointmentId, params.newAppointmentStatus);
  }
}

class UpdateAppointmentStatusParams {
  final String appointmentId;
  final AppointmentStatus newAppointmentStatus;

  UpdateAppointmentStatusParams(this.appointmentId, this.newAppointmentStatus);
}
