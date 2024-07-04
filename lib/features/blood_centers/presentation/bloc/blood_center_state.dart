part of 'blood_center_bloc.dart';

@immutable
sealed class BloodCenterState {}

final class BloodCenterInitial extends BloodCenterState {}

final class BloodCenterLoading extends BloodCenterState {}

final class BloodCenterAroundUserFetchedSuccess extends BloodCenterState {
  final List<BloodCenter> bloodCenters;

  BloodCenterAroundUserFetchedSuccess(this.bloodCenters);
}

final class BloodCenterAroundUserFetchedFailure extends BloodCenterState {
  final String message;

  BloodCenterAroundUserFetchedFailure(this.message);
}

final class BloodCenterByIdFetchedSuccess extends BloodCenterState {
  final BloodCenter center;

  BloodCenterByIdFetchedSuccess(this.center);
}

final class BloodCenterByIdFetchedFailure extends BloodCenterState {
  final String message;

  BloodCenterByIdFetchedFailure(this.message);
}
