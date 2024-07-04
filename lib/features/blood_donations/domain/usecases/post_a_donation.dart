import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/domain/repository/blood_donation_repository.dart';

class PostADonation implements Usecase<String, Donation> {
  final BloodDonationRespository bloodDonationRespoitory;

  PostADonation(this.bloodDonationRespoitory);
  @override
  Future<Either<Failure, String>> call(Donation params) async {
    return await bloodDonationRespoitory.postABloodDonation(params);
  }
}
