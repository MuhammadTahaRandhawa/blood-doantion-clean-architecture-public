import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/rating/data/datamodel/rating_model.dart';
import 'package:myapp/core/features/rating/data/datasources/ratings_remote_data_source.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';

import 'package:myapp/core/features/rating/domain/repository/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingsRemoteDataSource ratingsRemoteDataSource;

  RatingRepositoryImpl(this.ratingsRemoteDataSource);
  @override
  Future<Either<Failure, List<Rating>>> fetchDonationRatings(
      String donationId) async {
    try {
      final res =
          await ratingsRemoteDataSource.fetchDonationRatings(donationId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Rating>>> fetchRequestRatings(
      String requestId) async {
    try {
      final res = await ratingsRemoteDataSource.fetchRequestRatings(requestId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> postARatingOnDonation(
      Rating rating, String donationId) async {
    try {
      final res = await ratingsRemoteDataSource.postARatingOnDonation(
          RatingModel.fromRating(rating), donationId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> postARatingOnRequest(
      Rating rating, String requestId) async {
    try {
      final res = await ratingsRemoteDataSource.postARatingOnRequest(
          RatingModel.fromRating(rating), requestId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
