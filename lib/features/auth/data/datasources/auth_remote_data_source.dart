import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/core/error/exceptions.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpwithEmailPassword({
    required String email,
    required String password,
  });
  Future<String> logInwithEmailPassword({
    required String email,
    required String password,
  });
  Future<String> authenticateWithGoogle();
  Future<Unit> sendPasswordResetEmail(String email);
  Future<String> verifyPasswordResetCode(String code);
  Future<Unit> confirmPasswordReset(String code, String newPassword);
}

class AuthRemoteDataSourceimpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  AuthRemoteDataSourceimpl(this.firebaseAuth);

  @override
  Future<String> logInwithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (response.user == null) {
        throw ServerException('User is Null');
      }
      return '${response.user!.email}';
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> signUpwithEmailPassword(
      {required String email, required String password}) async {
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (response.user == null) {
        throw ServerException('User is Null');
      }
      return '${response.user!.email}';
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> authenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        User? user = authResult.user;
        if (user == null) {
          throw ServerException('User is Null');
        }
        return '${user.email}';
      } else {
        throw ServerException('User is Null');
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> verifyPasswordResetCode(String code) async {
    try {
      final res = await firebaseAuth.verifyPasswordResetCode(code);
      return res;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> confirmPasswordReset(String code, String newPassword) async {
    try {
      await firebaseAuth.confirmPasswordReset(
          code: code, newPassword: newPassword);
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
