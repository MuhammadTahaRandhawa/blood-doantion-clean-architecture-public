part of 'comments_bloc.dart';

@immutable
sealed class CommentsState {}

final class CommentsInitial extends CommentsState {}

final class CommentsFetchLoading extends CommentsState {}

final class CommentsPostLoading extends CommentsState {}

final class PostACommentFailure extends CommentsState {
  final String message;

  PostACommentFailure(this.message);
}

final class PostACommentSuccess extends CommentsState {}

final class FetchCommentsSuccess extends CommentsState {
  final List<Comment> comments;

  FetchCommentsSuccess(this.comments);
}

final class FetchCommentsFailure extends CommentsState {
  final String message;

  FetchCommentsFailure(this.message);
}
