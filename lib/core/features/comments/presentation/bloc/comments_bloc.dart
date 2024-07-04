import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/features/comments/domain/usecases/fetch_comments_on_donation.dart';
import 'package:myapp/core/features/comments/domain/usecases/fetch_comments_on_request.dart';
import 'package:myapp/core/features/comments/domain/usecases/post_a_comment_on_donation.dart';
import 'package:myapp/core/features/comments/domain/usecases/post_a_comment_on_request.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final FetchCommentsOnDonation fetchCommentsOnDonation;
  final PostACommentOnDonation postACommentOnDonation;
  final PostACommentOnRequest postACommentOnRequest;
  final FetchCommentsOnRequest fetchCommentsOnRequest;
  CommentsBloc(this.fetchCommentsOnDonation, this.postACommentOnDonation,
      this.postACommentOnRequest, this.fetchCommentsOnRequest)
      : super(CommentsInitial()) {
    //post comment on donation
    on<CommentOnDonationPosted>((event, emit) async {
      emit(CommentsPostLoading());
      final res = await postACommentOnDonation
          .call(DonationCommentParams(event.comment, event.donationId));
      res.fold((l) => emit(PostACommentFailure(l.message)),
          (r) => emit(PostACommentSuccess()));
    });

    //Post a comment on Request
    on<CommentOnRequestPosted>((event, emit) async {
      emit(CommentsPostLoading());
      final res = await postACommentOnRequest
          .call(RequestCommentParams(event.comment, event.requestId));
      res.fold((l) => emit(PostACommentFailure(l.message)),
          (r) => emit(PostACommentSuccess()));
    });

    //Fetch Donation Comments
    on<CommentsOnDonationFetched>((event, emit) async {
      emit(CommentsPostLoading());
      final res = await fetchCommentsOnDonation.call(event.donationId);
      res.fold((l) => emit(FetchCommentsFailure(l.message)),
          (r) => emit(FetchCommentsSuccess(r)));
    });

    //Fetch Request Comments
    on<CommentsOnRequestFetched>((event, emit) async {
      emit(CommentsPostLoading());
      final res = await fetchCommentsOnRequest.call(event.requestId);
      res.fold((l) => emit(FetchCommentsFailure(l.message)),
          (r) => emit(FetchCommentsSuccess(r)));
    });
  }
}
