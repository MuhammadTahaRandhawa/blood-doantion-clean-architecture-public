import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class UserLogIn implements Usecase<String, LoginParams> {
  final AuthRepository authRepository;
  UserLogIn(this.authRepository);
  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await authRepository.logInWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams(this.email, this.password);
}
