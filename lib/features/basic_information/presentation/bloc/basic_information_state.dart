part of 'basic_information_bloc.dart';

@immutable
sealed class BasicInformationState {}

final class BasicInformationInitial extends BasicInformationState {}

final class BasicInformationSubmitSuccess extends BasicInformationState {}

final class BasicInformationSubmitFailure extends BasicInformationState {
  final String message;

  BasicInformationSubmitFailure(this.message);
}

final class BasicInformationSubmitLoading extends BasicInformationState {}
