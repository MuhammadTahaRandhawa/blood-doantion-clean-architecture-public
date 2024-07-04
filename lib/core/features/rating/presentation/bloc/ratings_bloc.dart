import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';
import 'package:myapp/core/features/rating/domain/usecases/fetch_ratings_on_donation.dart';
import 'package:myapp/core/features/rating/domain/usecases/fetch_ratings_on_request.dart';
import 'package:myapp/core/features/rating/domain/usecases/post_a_rating_on_donation.dart';
import 'package:myapp/core/features/rating/domain/usecases/post_a_rating_on_request.dart';

part 'ratings_event.dart';
part 'ratings_state.dart';

class RatingsBloc extends Bloc<RatingsEvent, RatingsState> {
  final FetchRatingsOnDonation fetchRatingsOnDonation;
  final PostARatingOnDonation postARatingOnDonation;
  final PostARatingOnRequest postARatingOnRequest;
  final FetchRatingsOnRequest fetchRatingsOnRequest;
  RatingsBloc(this.fetchRatingsOnDonation, this.postARatingOnDonation,
      this.postARatingOnRequest, this.fetchRatingsOnRequest)
      : super(RatingsInitial()) {
    //post Rating on donation
    on<RatingOnDonationPosted>((event, emit) async {
      emit(RatingsPostLoading());
      final res = await postARatingOnDonation
          .call(DonationRatingParams(event.rating, event.donationId));
      res.fold((l) => emit(PostARatingFailure(l.message)),
          (r) => emit(PostARatingSuccess()));
    });

    //Post a Rating on Request
    on<RatingOnRequestPosted>((event, emit) async {
      emit(RatingsPostLoading());
      final res = await postARatingOnRequest
          .call(RequestRatingParams(event.rating, event.requestId));
      res.fold((l) => emit(PostARatingFailure(l.message)),
          (r) => emit(PostARatingSuccess()));
    });

    //Fetch Donation Ratings
    on<RatingsOnDonationFetched>((event, emit) async {
      emit(RatingsPostLoading());
      final res = await fetchRatingsOnDonation.call(event.donationId);
      res.fold((l) => emit(FetchRatingsFailure(l.message)),
          (r) => emit(FetchRatingsSuccess(r)));
    });

    //Fetch Request Ratings
    on<RatingsOnRequestFetched>((event, emit) async {
      emit(RatingsPostLoading());
      final res = await fetchRatingsOnRequest.call(event.requestId);
      res.fold((l) => emit(FetchRatingsFailure(l.message)),
          (r) => emit(FetchRatingsSuccess(r)));
    });
  }
}
