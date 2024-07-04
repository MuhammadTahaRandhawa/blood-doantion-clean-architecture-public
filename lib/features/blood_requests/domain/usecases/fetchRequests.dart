import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/domain/repository/blood_request_repository.dart';

class FetchRequests implements Usecase<List<Request>, Unit> {
  final BloodRequestRepository bloodRequestRepository;

  FetchRequests(this.bloodRequestRepository);

  @override
  Future<Either<Failure, List<Request>>> call(Unit params) async {
    return await bloodRequestRepository.fetchRequests();
  }
}
