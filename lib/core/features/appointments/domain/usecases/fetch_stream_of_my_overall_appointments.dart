import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:myapp/core/usecase/stream_usecase.dart';

class FetchStreamOfMyOverallAppointments
    implements StreamUseCase<List<Appointment>, Unit> {
  final AppointmentRepository appointmentRepository;

  FetchStreamOfMyOverallAppointments(this.appointmentRepository);
  @override
  Either<Failure, Stream<List<Appointment>>> call(Unit params) {
    return appointmentRepository.fetchStreamOfMyOverallAppointments();
  }
}
