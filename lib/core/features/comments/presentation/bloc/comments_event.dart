part of 'comments_bloc.dart';

@immutable
sealed class CommentsEvent {}

class CommentsOnDonationFetched extends CommentsEvent {
  final String donationId;

  CommentsOnDonationFetched(this.donationId);
}

class CommentsOnRequestFetched extends CommentsEvent {
  final String requestId;

  CommentsOnRequestFetched(this.requestId);
}

class CommentOnDonationPosted extends CommentsEvent {
  final String donationId;
  final Comment comment;
  CommentOnDonationPosted(this.donationId, this.comment);
}

class CommentOnRequestPosted extends CommentsEvent {
  final String requestId;
  final Comment comment;

  CommentOnRequestPosted(this.requestId, this.comment);
}
