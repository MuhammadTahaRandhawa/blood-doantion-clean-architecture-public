import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';

abstract interface class BloodDonationRespository {
  Future<Either<Failure, String>> postABloodDonation(Donation donation);
  Future<Either<Failure, List<Donation>>> fetchBloodDonations();
  Either<Failure, Stream<List<Donation>>> streamOfDonationsInCertainRadius(
      LatitudeLongitude latitudeLongitude);
  Future<Either<Failure, List<Donation>>> fetchBloodDonationsInCertainRadius(
      LatitudeLongitude latitudeLongitude);
  Future<Either<Failure, Donation>> fetchDonationById(String id);

  Future<Either<Failure, Unit>> turnOffADonation(Donation donation);

  Future<Either<Failure, List<Donation>>> fetchMyDonations();
}
