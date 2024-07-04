import 'package:myapp/core/features/rating/domain/entities/rating.dart';

class RatingModel extends Rating {
  RatingModel(
      {required super.ratingId,
      required super.ratingType,
      required super.userId,
      required super.rating,
      required super.timestamp,
      required super.userProfileImageUrl,
      required super.userName});

  factory RatingModel.fromRating(Rating rating) {
    return RatingModel(
        ratingId: rating.ratingId,
        userName: rating.userName,
        ratingType: rating.ratingType,
        userId: rating.userId,
        userProfileImageUrl: rating.userProfileImageUrl,
        rating: rating.rating,
        timestamp: rating.timestamp);
  }

  factory RatingModel.fromJson(
      Map<String, dynamic> map, RatingType ratingType) {
    return RatingModel(
        ratingId: map['ratingId'],
        userName: map['userName'],
        ratingType: ratingType,
        userId: map['userId'],
        userProfileImageUrl: map['userProfileImageUrl'],
        rating: map['rating'],
        timestamp: map['timestamp'].toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'ratingId': ratingId,
      'userId': userId,
      'userProfileImageUrl': userProfileImageUrl,
      'rating': rating,
      'timestamp': timestamp,
      'userName': userName
    };
  }
}
