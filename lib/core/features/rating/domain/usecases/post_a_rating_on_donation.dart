import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';
import 'package:myapp/core/features/rating/domain/repository/rating_repository.dart';

import 'package:myapp/core/usecase/usecase.dart';

class PostARatingOnDonation implements Usecase<Unit, DonationRatingParams> {
  final RatingRepository ratingRepositpry;

  PostARatingOnDonation(this.ratingRepositpry);
  @override
  Future<Either<Failure, Unit>> call(DonationRatingParams params) async {
    return await ratingRepositpry.postARatingOnDonation(
        params.rating, params.donationId);
  }
}

class DonationRatingParams {
  final Rating rating;
  final String donationId;

  DonationRatingParams(this.rating, this.donationId);
}
