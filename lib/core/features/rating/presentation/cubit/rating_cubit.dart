import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';

class RatingCubit extends Cubit<List<Rating>> {
  RatingCubit() : super([]);

  void initializeRatings(List<Rating> ratings) {
    emit(ratings);
  }

  void addRating(Rating rating) {
    emit([...state, rating]);
  }

  void updateRating(Rating oldRating, Rating newRating) {
    final ratings = state.where((rating) => rating != oldRating).toList();
    emit([...ratings, newRating]);
  }

  void emptyRatings() {
    emit([]);
  }

  double getRatingsAverage(List<Rating> ratings) {
    double total = 0.0;
    for (var rating in ratings) {
      total += rating.rating;
    }
    if (total == 0.0) {
      return 0.0;
    }
    double length = ratings.length.toDouble();

    return total / length;
  }
}
