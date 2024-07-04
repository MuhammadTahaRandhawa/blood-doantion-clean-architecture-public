import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Comment {
  final String commentId;
  final String userId, userName;
  final String? userProfileImageUrl;
  final String text;
  final DateTime timestamp;
  final CommentType commentType;

  Comment(
      {String? commentId,
      required this.commentType,
      required this.userName,
      required this.userId,
      required this.text,
      required this.timestamp,
      required this.userProfileImageUrl})
      : commentId = commentId ?? uuid.v4();
}

enum CommentType { donation, request, centre }
