import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/domain/repository/blood_donation_repository.dart';

class TurnOffDonation implements Usecase<Unit, Donation> {
  final BloodDonationRespository bloodDonationRespository;

  TurnOffDonation(this.bloodDonationRespository);
  @override
  Future<Either<Failure, Unit>> call(Donation params) async {
    return await bloodDonationRespository.turnOffADonation(params);
  }
}
