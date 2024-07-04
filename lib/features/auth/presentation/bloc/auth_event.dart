part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class OnSignUpwithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  OnSignUpwithEmailPassword({required this.email, required this.password});
}

class OnLoginWithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  OnLoginWithEmailPassword({required this.email, required this.password});
}

class OnAuthenticatedWithGoogle extends AuthEvent {}

class PasswordResetCodeVerified extends AuthEvent {
  final String code;

  PasswordResetCodeVerified(this.code);
}

class PasswordResetEmailSent extends AuthEvent {
  final String email;

  PasswordResetEmailSent(this.email);
}

class PasswordResetConfirmed extends AuthEvent {
  final String code, newPassword;

  PasswordResetConfirmed(this.code, this.newPassword);
}
