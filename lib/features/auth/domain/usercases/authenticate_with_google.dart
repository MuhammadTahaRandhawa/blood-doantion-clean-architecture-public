import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class AuthenticateWithGoogle implements Usecase<String, Unit> {
  final AuthRepository authRepository;

  AuthenticateWithGoogle(this.authRepository);
  @override
  Future<Either<Failure, String>> call(Unit params) async {
    return await authRepository.authenticateWithGoogle();
  }
}
