import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/features/comments/domain/repository/comment_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class FetchCommentsOnRequest implements Usecase<List<Comment>, String> {
  final CommentRepository commentRepositpry;

  FetchCommentsOnRequest(this.commentRepositpry);
  @override
  Future<Either<Failure, List<Comment>>> call(String params) async {
    return await commentRepositpry.fetchRequestComments(params);
  }
}
