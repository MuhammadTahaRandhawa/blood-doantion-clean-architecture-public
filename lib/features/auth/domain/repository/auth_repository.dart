import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> authenticateWithGoogle();

  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);
  Future<Either<Failure, String>> verifyPasswordResetCode(String code);

  Future<Either<Failure, Unit>> confirmPasswordReset(
      String code, String newPassword);
}
