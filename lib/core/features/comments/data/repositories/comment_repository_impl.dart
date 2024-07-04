import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/comments/data/datamodel/comment_model.dart';
import 'package:myapp/core/features/comments/data/datasources/comments_remote_data_source.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/features/comments/domain/repository/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentsRemoteDataSource commentsRemoteDataSource;

  CommentRepositoryImpl(this.commentsRemoteDataSource);
  @override
  Future<Either<Failure, List<Comment>>> fetchDonationComments(
      String donationId) async {
    try {
      final res =
          await commentsRemoteDataSource.fetchDonationComments(donationId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> fetchRequestComments(
      String requestId) async {
    try {
      final res =
          await commentsRemoteDataSource.fetchRequestComments(requestId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> postACommentOnDonation(
      Comment comment, String donationId) async {
    try {
      final res = await commentsRemoteDataSource.postACommentOnDonation(
          CommentModel.fromComment(comment), donationId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> postACommentOnRequest(
      Comment comment, String requestId) async {
    try {
      final res = await commentsRemoteDataSource.postACommentOnRequest(
          CommentModel.fromComment(comment), requestId);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
