part of 'loading_bloc.dart';

@immutable
sealed class LoadingEvent {}

class UserDataFetched extends LoadingEvent {}
