import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/domain/repository/blood_donation_repository.dart';

class FetchDonationById implements Usecase<Donation, String> {
  final BloodDonationRespository bloodDonationRespository;

  FetchDonationById(this.bloodDonationRespository);
  @override
  Future<Either<Failure, Donation>> call(String params) async {
    return await bloodDonationRespository.fetchDonationById(params);
  }
}
