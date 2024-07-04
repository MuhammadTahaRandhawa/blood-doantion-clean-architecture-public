part of 'loading_bloc.dart';

@immutable
sealed class LoadingState {}

final class LoadingInitial extends LoadingState {}

final class UserFetchedLoading extends LoadingState {}

final class UserFetchedSuccess extends LoadingState {
  final User user;

  UserFetchedSuccess(this.user);
}

final class UserFetchedFailure extends LoadingState {
  final String message;

  UserFetchedFailure(this.message);
}
