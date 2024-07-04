import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements Usecase<String, UserSignupParams> {
  final AuthRepository authRepository;
  UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, String>> call(UserSignupParams params) async {
    return await authRepository.signUpWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserSignupParams {
  final String email;
  final String password;

  UserSignupParams(this.email, this.password);
}
