part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

final class AuthSuccess extends AuthState {
  final String email;
  AuthSuccess(this.email);
}

final class PasswordResetCodeVerifiedFailed extends AuthState {
  final String message;

  PasswordResetCodeVerifiedFailed(this.message);
}

final class PasswordResetCodeVerifiedSuccess extends AuthState {
  final String email;

  PasswordResetCodeVerifiedSuccess(this.email);
}

final class PasswordResetEmailSentFailure extends AuthState {
  final String message;

  PasswordResetEmailSentFailure(this.message);
}

final class PasswordResetEmailSentSuccess extends AuthState {}

final class PasswordResetConfirmedFailure extends AuthState {
  final String message;

  PasswordResetConfirmedFailure(this.message);
}

final class PasswordResetConfirmedSuccess extends AuthState {}
