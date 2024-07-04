import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/stream_usecase.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/domain/repository/blood_request_repository.dart';

class StreamOfRequestsInCertainRadius
    implements StreamUseCase<List<Request>, LatitudeLongitude> {
  final BloodRequestRepository bloodRequestRepository;

  StreamOfRequestsInCertainRadius(this.bloodRequestRepository);
  @override
  Either<Failure, Stream<List<Request>>> call(LatitudeLongitude params) {
    return bloodRequestRepository.streamOfRequestsInCertainRadius(params);
  }
}
