import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/features/rating/data/datamodel/rating_model.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';

abstract interface class RatingsRemoteDataSource {
  Future<Unit> postARatingOnDonation(
      RatingModel ratingModel, String donationId);
  Future<List<RatingModel>> fetchDonationRatings(String donationId);
  Future<Unit> postARatingOnRequest(RatingModel ratingModel, String requestId);
  Future<List<RatingModel>> fetchRequestRatings(String requestId);
}

class RatingsRemoteDataSourceImpl implements RatingsRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  RatingsRemoteDataSourceImpl(this.firebaseFirestore);
  @override
  Future<List<RatingModel>> fetchDonationRatings(String donationID) async {
    try {
      final response = await firebaseFirestore
          .collection('donations')
          .doc(donationID)
          .collection('ratings')
          .get();
      final ratings = response.docs
          .map((e) => RatingModel.fromJson(e.data(), RatingType.donation))
          .toList();
      return ratings;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RatingModel>> fetchRequestRatings(String requestID) async {
    try {
      final response = await firebaseFirestore
          .collection('requests')
          .doc(requestID)
          .collection('ratings')
          .get();
      final ratings = response.docs
          .map((e) => RatingModel.fromJson(e.data(), RatingType.request))
          .toList();
      return ratings;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> postARatingOnDonation(
      RatingModel ratingModel, String donationId) async {
    try {
      await firebaseFirestore
          .collection('donations')
          .doc(donationId)
          .collection('ratings')
          .doc(ratingModel.ratingId)
          .set(ratingModel.toJson(), SetOptions(merge: true));
      return (unit);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> postARatingOnRequest(
      RatingModel ratingModel, String requestId) async {
    try {
      await firebaseFirestore
          .collection('requests')
          .doc(requestId)
          .collection('ratings')
          .doc(ratingModel.ratingId)
          .set(ratingModel.toJson(), SetOptions(merge: true));
      return (unit);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
