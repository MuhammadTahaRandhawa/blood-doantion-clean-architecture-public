part of 'ratings_bloc.dart';

@immutable
sealed class RatingsState {}

final class RatingsInitial extends RatingsState {}

final class RatingsFetchLoading extends RatingsState {}

final class RatingsPostLoading extends RatingsState {}

final class PostARatingFailure extends RatingsState {
  final String message;

  PostARatingFailure(this.message);
}

final class PostARatingSuccess extends RatingsState {}

final class FetchRatingsSuccess extends RatingsState {
  final List<Rating> ratings;

  FetchRatingsSuccess(this.ratings);
}

final class FetchRatingsFailure extends RatingsState {
  final String message;

  FetchRatingsFailure(this.message);
}
