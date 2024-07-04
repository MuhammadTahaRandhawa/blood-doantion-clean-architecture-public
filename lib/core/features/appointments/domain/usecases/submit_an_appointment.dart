import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class SubmitAnAppointment implements Usecase<Unit, Appointment> {
  final AppointmentRepository appointmentRepository;

  SubmitAnAppointment(this.appointmentRepository);
  @override
  Future<Either<Failure, Unit>> call(Appointment params) async {
    return await appointmentRepository.submitAnAppointment(params);
  }
}
