import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';
import 'package:myapp/core/features/rating/domain/repository/rating_repository.dart';

import 'package:myapp/core/usecase/usecase.dart';

class PostARatingOnRequest implements Usecase<Unit, RequestRatingParams> {
  final RatingRepository ratingRepository;

  PostARatingOnRequest(this.ratingRepository);
  @override
  Future<Either<Failure, Unit>> call(RequestRatingParams params) async {
    return await ratingRepository.postARatingOnRequest(
        params.rating, params.requestId);
  }
}

class RequestRatingParams {
  final Rating rating;
  final String requestId;

  RequestRatingParams(this.rating, this.requestId);
}
