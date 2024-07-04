import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';
import 'package:myapp/core/features/rating/domain/repository/rating_repository.dart';

import 'package:myapp/core/usecase/usecase.dart';

class FetchRatingsOnDonation implements Usecase<List<Rating>, String> {
  final RatingRepository ratingRepository;

  FetchRatingsOnDonation(this.ratingRepository);
  @override
  Future<Either<Failure, List<Rating>>> call(String params) async {
    return await ratingRepository.fetchDonationRatings(params);
  }
}
