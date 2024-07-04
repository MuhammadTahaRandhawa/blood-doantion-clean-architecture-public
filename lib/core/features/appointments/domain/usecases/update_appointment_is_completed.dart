import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class UpdateIsAppointmentCompleted
    implements Usecase<Unit, UpdateIsAppointmentCompletedParams> {
  final AppointmentRepository appointmentRepository;

  UpdateIsAppointmentCompleted(this.appointmentRepository);
  @override
  Future<Either<Failure, Unit>> call(
      UpdateIsAppointmentCompletedParams params) async {
    return await appointmentRepository.updateAppointmentIsCompleted(
        params.appointmentId, params.meIsCreater, params.isCompleted);
  }
}

class UpdateIsAppointmentCompletedParams {
  final String appointmentId;
  final bool meIsCreater;
  final bool isCompleted;

  UpdateIsAppointmentCompletedParams(
      this.appointmentId, this.meIsCreater, this.isCompleted);
}
