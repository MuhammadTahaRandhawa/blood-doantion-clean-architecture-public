import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';

class CommentCubit extends Cubit<List<Comment>> {
  CommentCubit() : super([]);

  void initializeComments(List<Comment> comments) {
    emit(comments);
  }

  void addComment(Comment comment) {
    emit([...state, comment]);
  }

  void emptyComments() {
    emit([]);
  }
}
