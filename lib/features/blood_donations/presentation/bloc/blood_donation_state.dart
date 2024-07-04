part of 'blood_donation_bloc.dart';

@immutable
sealed class BloodDonationState {}

final class BloodDonationInitial extends BloodDonationState {}

final class BloodDonationFetchedFailure extends BloodDonationState {
  final String message;

  BloodDonationFetchedFailure(this.message);
}

final class BloodDonationLoading extends BloodDonationState {}

final class BloodDonationFetchedSuccess extends BloodDonationState {
  final List<Donation> donations;

  BloodDonationFetchedSuccess(this.donations);
}

final class BloodDonationStreamSuccess extends BloodDonationState {
  final Stream<List<Donation>> stream;

  BloodDonationStreamSuccess(this.stream);
}

final class BloodDonationStreamFailure extends BloodDonationState {
  final String message;

  BloodDonationStreamFailure(this.message);
}

final class BloodDonationPostSuccess extends BloodDonationState {
  final String docRef;

  BloodDonationPostSuccess(this.docRef);
}

final class BloodDonationPostLoading extends BloodDonationState {}

final class BloodDonationPostFailure extends BloodDonationState {
  final String message;

  BloodDonationPostFailure(this.message);
}

final class BloodDonationInsideCertainRadiusSuccess extends BloodDonationState {
  final List<Donation> donations;

  BloodDonationInsideCertainRadiusSuccess(this.donations);
}

final class BloodDonationInsideCertainRadiusFailure extends BloodDonationState {
  final String message;

  BloodDonationInsideCertainRadiusFailure(this.message);
}

final class BloodDonationByIdFetchedSuccess extends BloodDonationState {
  final Donation donation;

  BloodDonationByIdFetchedSuccess(this.donation);
}

final class BloodDonationByIdFetchedFailure extends BloodDonationState {
  final String message;

  BloodDonationByIdFetchedFailure(this.message);
}

final class MyBloodDonationsFetchedSuccess extends BloodDonationState {
  final List<Donation> myDonations;

  MyBloodDonationsFetchedSuccess(this.myDonations);
}

final class MyBloodDonationsFetchedFailure extends BloodDonationState {
  final String message;

  MyBloodDonationsFetchedFailure(this.message);
}

final class BloodDonationTurnedOffSuccess extends BloodDonationState {}

final class BloodDonationTurnedOffFailure extends BloodDonationState {
  final String message;

  BloodDonationTurnedOffFailure(this.message);
}
