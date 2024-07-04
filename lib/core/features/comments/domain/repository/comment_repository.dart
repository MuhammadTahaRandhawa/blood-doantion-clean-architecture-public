import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';

abstract interface class CommentRepository {
  Future<Either<Failure, Unit>> postACommentOnDonation(
      Comment comment, String donationId);
  Future<Either<Failure, List<Comment>>> fetchDonationComments(
      String donationId);
  Future<Either<Failure, Unit>> postACommentOnRequest(
      Comment comment, String requestId);
  Future<Either<Failure, List<Comment>>> fetchRequestComments(String requestId);
}
