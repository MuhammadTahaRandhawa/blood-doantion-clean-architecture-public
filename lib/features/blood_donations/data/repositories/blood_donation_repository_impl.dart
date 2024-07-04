import 'package:fpdart/fpdart.dart';

import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_donations/data/datamodel/donation_model.dart';
import 'package:myapp/features/blood_donations/data/datasources/blood_donation_datasources.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/domain/repository/blood_donation_repository.dart';

class BloodDonationRepositoryImpl implements BloodDonationRespository {
  final BloodDonationDataSources bloodDonationDataSources;

  BloodDonationRepositoryImpl(this.bloodDonationDataSources);
  @override
  Future<Either<Failure, List<Donation>>> fetchBloodDonations() async {
    try {
      final response = await bloodDonationDataSources.fetchDonations();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, String>> postABloodDonation(Donation donation) async {
    try {
      final response = await bloodDonationDataSources
          .postANewDonation(DonationModel.fromDonation(donation));
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Either<Failure, Stream<List<Donation>>> streamOfDonationsInCertainRadius(
      LatitudeLongitude latitudeLongitude) {
    try {
      final response = bloodDonationDataSources
          .streamOfDonationsInCertainRadius(latitudeLongitude);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Donation>>> fetchBloodDonationsInCertainRadius(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final response = await bloodDonationDataSources
          .fetchDonationsInCertainRadius(latitudeLongitude);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Donation>> fetchDonationById(String id) async {
    try {
      final response = await bloodDonationDataSources.fetchDonationById(id);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Donation>>> fetchMyDonations() async {
    try {
      final response = await bloodDonationDataSources.fetchMyDonations();
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> turnOffADonation(Donation donation) async {
    try {
      final response = await bloodDonationDataSources
          .turnOffADonation(DonationModel.fromDonation(donation));
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }
}
