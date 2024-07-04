import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/features/comments/domain/repository/comment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class PostACommentOnRequest implements Usecase<Unit, RequestCommentParams> {
  final CommentRepository commentRepositpry;

  PostACommentOnRequest(this.commentRepositpry);
  @override
  Future<Either<Failure, Unit>> call(RequestCommentParams params) async {
    return await commentRepositpry.postACommentOnRequest(
        params.comment, params.requestId);
  }
}

class RequestCommentParams {
  final Comment comment;
  final String requestId;

  RequestCommentParams(this.comment, this.requestId);
}
