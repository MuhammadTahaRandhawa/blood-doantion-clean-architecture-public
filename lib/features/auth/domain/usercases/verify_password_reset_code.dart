import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class VerifyPasswordResetCode implements Usecase<String, String> {
  final AuthRepository authRepository;

  VerifyPasswordResetCode(this.authRepository);
  @override
  Future<Either<Failure, String>> call(String params) async {
    return await authRepository.verifyPasswordResetCode(params);
  }
}
