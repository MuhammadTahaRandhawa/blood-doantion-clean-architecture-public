import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/features/auth/domain/usercases/authenticate_with_google.dart';
import 'package:myapp/features/auth/domain/usercases/confirm_password_reset.dart';
import 'package:myapp/features/auth/domain/usercases/send_password_reset_email.dart';
import 'package:myapp/features/auth/domain/usercases/user_login.dart';
import 'package:myapp/features/auth/domain/usercases/user_sign_up.dart';
import 'package:myapp/features/auth/domain/usercases/verify_password_reset_code.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogIn _userLogIn;
  final AuthenticateWithGoogle _authenticateWithGoogle;
  final ConfirmPasswordReset confirmPasswordReset;
  final SendPasswordResetEmail sendPasswordResetEmail;
  final VerifyPasswordResetCode verifyPasswordResetCode;
  AuthBloc(
      UserSignUp userSignUp,
      UserLogIn userLogIn,
      AuthenticateWithGoogle authenticateWithGoogle,
      this.confirmPasswordReset,
      this.sendPasswordResetEmail,
      this.verifyPasswordResetCode)
      : _userSignUp = userSignUp,
        _userLogIn = userLogIn,
        _authenticateWithGoogle = authenticateWithGoogle,
        super(AuthInitial()) {
    on((event, emit) => emit(AuthLoading()));
    on<OnSignUpwithEmailPassword>(onSignUp);
    on<OnLoginWithEmailPassword>(onLogIn);
    on<OnAuthenticatedWithGoogle>(onAuthenticatedWithGoogle);
    on<PasswordResetCodeVerified>(passwordResetCodeVerified);
    on<PasswordResetEmailSent>(passwordResetEmailSent);
    on<PasswordResetConfirmed>(passwordResetConfirmed);
  }

  onSignUp(OnSignUpwithEmailPassword event, Emitter emit) async {
    final reponse =
        await _userSignUp.call(UserSignupParams(event.email, event.password));

    reponse.fold((failure) => emit(AuthFailure(failure.message)),
        (email) => emit(AuthSuccess(email)));
  }

  onLogIn(OnLoginWithEmailPassword event, Emitter emit) async {
    final response =
        await _userLogIn.call(LoginParams(event.email, event.password));

    response.fold((failure) => emit(AuthFailure(failure.message)),
        (emailId) => emit(AuthSuccess(emailId)));
  }

  onAuthenticatedWithGoogle(
      OnAuthenticatedWithGoogle event, Emitter emit) async {
    final response = await _authenticateWithGoogle.call(unit);
    response.fold(
        (l) => emit(AuthFailure(l.message)), (r) => emit(AuthSuccess(r)));
  }

  passwordResetCodeVerified(
      PasswordResetCodeVerified event, Emitter emit) async {
    final res = await verifyPasswordResetCode.call(event.code);
    res.fold((l) => emit(PasswordResetCodeVerifiedFailed(l.message)),
        (r) => emit(PasswordResetCodeVerifiedSuccess(r)));
  }

  passwordResetEmailSent(PasswordResetEmailSent event, Emitter emit) async {
    final res = await sendPasswordResetEmail.call(event.email);
    res.fold((l) => emit(PasswordResetEmailSentFailure(l.message)),
        (r) => emit(PasswordResetEmailSentSuccess()));
  }

  passwordResetConfirmed(PasswordResetConfirmed event, Emitter emit) async {
    final res = await confirmPasswordReset
        .call(ConfirmPasswordResetParams(event.code, event.newPassword));
    res.fold((l) => emit(PasswordResetConfirmedFailure(l.message)),
        (r) => emit(PasswordResetConfirmedSuccess()));
  }
}
