import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';

abstract interface class RatingRepository {
  Future<Either<Failure, Unit>> postARatingOnDonation(
      Rating rating, String donationId);
  Future<Either<Failure, List<Rating>>> fetchDonationRatings(String donationId);
  Future<Either<Failure, Unit>> postARatingOnRequest(
      Rating rating, String requestId);
  Future<Either<Failure, List<Rating>>> fetchRequestRatings(String requestId);
}
