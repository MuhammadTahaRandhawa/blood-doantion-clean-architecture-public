import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class ConfirmPasswordReset
    implements Usecase<Unit, ConfirmPasswordResetParams> {
  final AuthRepository authRepository;

  ConfirmPasswordReset(this.authRepository);
  @override
  Future<Either<Failure, Unit>> call(ConfirmPasswordResetParams params) async {
    return await authRepository.confirmPasswordReset(
        params.code, params.newPassword);
  }
}

class ConfirmPasswordResetParams {
  final String code, newPassword;

  ConfirmPasswordResetParams(this.code, this.newPassword);
}
