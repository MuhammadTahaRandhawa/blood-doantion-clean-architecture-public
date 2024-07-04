import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class FetchAppointmentsById implements Usecase<Appointment, String> {
  final AppointmentRepository appointmentRepository;

  FetchAppointmentsById(this.appointmentRepository);
  @override
  Future<Either<Failure, Appointment>> call(String params) async {
    return await appointmentRepository.fetchAppointmentById(params);
  }
}
