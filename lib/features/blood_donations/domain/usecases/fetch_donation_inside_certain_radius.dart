import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/domain/repository/blood_donation_repository.dart';

class FetchDonationsInsideCertainRadius
    implements Usecase<List<Donation>, LatitudeLongitude> {
  final BloodDonationRespository bloodDonationRespository;

  FetchDonationsInsideCertainRadius(this.bloodDonationRespository);
  @override
  Future<Either<Failure, List<Donation>>> call(LatitudeLongitude params) async {
    return await bloodDonationRespository
        .fetchBloodDonationsInCertainRadius(params);
  }
}
