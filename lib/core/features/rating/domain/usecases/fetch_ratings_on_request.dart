import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';
import 'package:myapp/core/features/rating/domain/repository/rating_repository.dart';

import 'package:myapp/core/usecase/usecase.dart';

class FetchRatingsOnRequest implements Usecase<List<Rating>, String> {
  final RatingRepository ratingRepositpry;

  FetchRatingsOnRequest(this.ratingRepositpry);
  @override
  Future<Either<Failure, List<Rating>>> call(String params) async {
    return await ratingRepositpry.fetchRequestRatings(params);
  }
}
