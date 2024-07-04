import 'package:myapp/core/features/comments/domain/entities/comment.dart';

class CommentModel extends Comment {
  CommentModel(
      {required super.commentId,
      required super.commentType,
      required super.userId,
      required super.text,
      required super.timestamp,
      required super.userProfileImageUrl,
      required super.userName});

  factory CommentModel.fromComment(Comment comment) {
    return CommentModel(
        commentId: comment.commentId,
        userName: comment.userName,
        commentType: comment.commentType,
        userId: comment.userId,
        userProfileImageUrl: comment.userProfileImageUrl,
        text: comment.text,
        timestamp: comment.timestamp);
  }

  factory CommentModel.fromJson(
      Map<String, dynamic> map, CommentType commentType) {
    return CommentModel(
        commentId: map['commentId'],
        userName: map['userName'],
        commentType: commentType,
        userId: map['userId'],
        userProfileImageUrl: map['userProfileImageUrl'],
        text: map['text'],
        timestamp: map['timestamp'].toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'userProfileImageUrl': userProfileImageUrl,
      'text': text,
      'timestamp': timestamp,
      'userName': userName
    };
  }

  // // Function to convert CommentType enum to string
  // String getCommentTypeAsString(CommentType commentType) {
  //   switch (commentType) {
  //     case CommentType.donation:
  //       return 'donation';
  //     case CommentType.request:
  //       return 'request';
  //     case CommentType.centre:
  //       return 'centre';
  //     default:
  //       throw ArgumentError('Invalid enum value');
  //   }
  // }

  // // Function to convert string to CommentType enum
  // static CommentType getCommentTypeFromString(String commentType) {
  //   switch (commentType) {
  //     case 'donation':
  //       return CommentType.donation;
  //     case 'request':
  //       return CommentType.request;
  //     case 'centre':
  //       return CommentType.centre;
  //     default:
  //       throw ArgumentError('Invalid string value');
  //   }
  // }
}
