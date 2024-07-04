import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/domain/repository/blood_request_repository.dart';

class FetchRequestById implements Usecase<Request, String> {
  final BloodRequestRepository bloodRequestRepository;

  FetchRequestById(this.bloodRequestRepository);
  @override
  Future<Either<Failure, Request>> call(String params) async {
    return await bloodRequestRepository.fetchRequestById(params);
  }
}
