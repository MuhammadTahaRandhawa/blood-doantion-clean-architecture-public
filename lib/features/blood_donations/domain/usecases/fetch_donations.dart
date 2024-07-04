import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/domain/repository/blood_donation_repository.dart';

class FetchDonations implements Usecase<List<Donation>, Unit> {
  final BloodDonationRespository bloodDonationRespoitory;

  FetchDonations(this.bloodDonationRespoitory);
  @override
  Future<Either<Failure, List<Donation>>> call(Unit params) async {
    return await bloodDonationRespoitory.fetchBloodDonations();
  }
}
