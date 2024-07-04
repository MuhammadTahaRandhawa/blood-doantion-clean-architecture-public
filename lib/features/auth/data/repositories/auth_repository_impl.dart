import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl(this.authRemoteDataSource);

  @override
  Future<Either<Failure, String>> logInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final res = await authRemoteDataSource.logInwithEmailPassword(
          email: email, password: password);

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword(
      {required String email, required String password}) async {
    try {
      final res = await authRemoteDataSource.signUpwithEmailPassword(
          email: email, password: password);

      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, String>> authenticateWithGoogle() async {
    try {
      final res = await authRemoteDataSource.authenticateWithGoogle();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      final res = await authRemoteDataSource.sendPasswordResetEmail(email);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, String>> verifyPasswordResetCode(String code) async {
    try {
      final res = await authRemoteDataSource.verifyPasswordResetCode(code);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmPasswordReset(
      String code, String newPassword) async {
    try {
      final res =
          await authRemoteDataSource.confirmPasswordReset(code, newPassword);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
