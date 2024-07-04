part of 'blood_donation_bloc.dart';

@immutable
sealed class BloodDonationEvent {}

class BloodDonationFetched extends BloodDonationEvent {}

class BloodDonationStreamInsideARadiusFetched extends BloodDonationEvent {
  final LatitudeLongitude latitudeLongitude;

  BloodDonationStreamInsideARadiusFetched(this.latitudeLongitude);
}

class BloodDonationPosted extends BloodDonationEvent {
  final Donation donation;

  BloodDonationPosted(this.donation);
}

class BloodDonationInsideCertainRadiusFetched extends BloodDonationEvent {
  final LatitudeLongitude latitudeLongitude;

  BloodDonationInsideCertainRadiusFetched(this.latitudeLongitude);
}

class BloodDonationByIdFetched extends BloodDonationEvent {
  final String id;

  BloodDonationByIdFetched(this.id);
}

class MyBloodDonationsFetched extends BloodDonationEvent {}

class BloodDonationTurnedOff extends BloodDonationEvent {
  final Donation bloodDonation;

  BloodDonationTurnedOff(this.bloodDonation);
}
