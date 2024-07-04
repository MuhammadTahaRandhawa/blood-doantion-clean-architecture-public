part of 'ratings_bloc.dart';

@immutable
sealed class RatingsEvent {}

class RatingsOnDonationFetched extends RatingsEvent {
  final String donationId;

  RatingsOnDonationFetched(this.donationId);
}

class RatingsOnRequestFetched extends RatingsEvent {
  final String requestId;

  RatingsOnRequestFetched(this.requestId);
}

class RatingOnDonationPosted extends RatingsEvent {
  final String donationId;
  final Rating rating;
  RatingOnDonationPosted(this.donationId, this.rating);
}

class RatingOnRequestPosted extends RatingsEvent {
  final String requestId;
  final Rating rating;

  RatingOnRequestPosted(this.requestId, this.rating);
}
