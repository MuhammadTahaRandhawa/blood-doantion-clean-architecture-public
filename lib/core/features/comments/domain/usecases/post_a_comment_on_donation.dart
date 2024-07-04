import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/features/comments/domain/repository/comment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class PostACommentOnDonation implements Usecase<Unit, DonationCommentParams> {
  final CommentRepository commentRepositpry;

  PostACommentOnDonation(this.commentRepositpry);
  @override
  Future<Either<Failure, Unit>> call(DonationCommentParams params) async {
    return await commentRepositpry.postACommentOnDonation(
        params.comment, params.donationId);
  }
}

class DonationCommentParams {
  final Comment comment;
  final String donationId;

  DonationCommentParams(this.comment, this.donationId);
}
