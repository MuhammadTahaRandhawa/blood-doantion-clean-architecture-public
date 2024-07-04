import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/domain/repository/blood_request_repository.dart';

class FetchBloodRequestsInCertainRadius
    implements Usecase<List<Request>, LatitudeLongitude> {
  final BloodRequestRepository bloodRequestRepository;

  FetchBloodRequestsInCertainRadius(this.bloodRequestRepository);
  @override
  Future<Either<Failure, List<Request>>> call(LatitudeLongitude params) async {
    return await bloodRequestRepository.fetchRequestsInCertainRadius(params);
  }
}
