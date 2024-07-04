import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/stream_usecase.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/domain/repository/blood_donation_repository.dart';

class StreamOfDonationsInCertainRadius
    implements StreamUseCase<List<Donation>, LatitudeLongitude> {
  final BloodDonationRespository bloodDonationRespoitory;

  StreamOfDonationsInCertainRadius(this.bloodDonationRespoitory);
  @override
  Either<Failure, Stream<List<Donation>>> call(LatitudeLongitude params) {
    return bloodDonationRespoitory.streamOfDonationsInCertainRadius(params);
  }
}
