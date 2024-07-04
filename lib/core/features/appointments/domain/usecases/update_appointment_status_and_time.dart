import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class UpdateAppointmentStatusAndTime
    implements Usecase<Unit, UpdateAppointmentStatusAndTimeParams> {
  final AppointmentRepository appointmentRepository;

  UpdateAppointmentStatusAndTime(this.appointmentRepository);
  @override
  Future<Either<Failure, Unit>> call(
      UpdateAppointmentStatusAndTimeParams params) async {
    return await appointmentRepository.updateAppointmentStatusAndTime(
        params.appointmentId, params.appointmentStatus, params.updatedDateTime);
  }
}

class UpdateAppointmentStatusAndTimeParams {
  final String appointmentId;
  final AppointmentStatus appointmentStatus;
  final DateTime updatedDateTime;

  UpdateAppointmentStatusAndTimeParams(
      this.appointmentId, this.appointmentStatus, this.updatedDateTime);
}
