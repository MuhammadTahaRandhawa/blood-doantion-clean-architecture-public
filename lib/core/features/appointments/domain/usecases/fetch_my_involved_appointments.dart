import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class FetchMyInvlovedAppointments implements Usecase<List<Appointment>, Unit> {
  final AppointmentRepository appointmentRepository;

  FetchMyInvlovedAppointments(this.appointmentRepository);
  @override
  Future<Either<Failure, List<Appointment>>> call(Unit params) async {
    return await appointmentRepository.fetchMyInvolvedAppointments();
  }
}
