import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class SendPasswordResetEmail implements Usecase<Unit, String> {
  final AuthRepository authRepository;

  SendPasswordResetEmail(this.authRepository);
  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await authRepository.sendPasswordResetEmail(params);
  }
}
