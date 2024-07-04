import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Rating {
  final String userId, userName;
  final String? userProfileImageUrl;
  final double rating;
  final DateTime timestamp;
  final RatingType ratingType;
  final String ratingId;

  Rating(
      {String? ratingId,
      required this.ratingType,
      required this.userName,
      required this.userId,
      required this.rating,
      required this.timestamp,
      required this.userProfileImageUrl})
      : ratingId = ratingId ?? uuid.v4();
}

enum RatingType { donation, request, centre }
