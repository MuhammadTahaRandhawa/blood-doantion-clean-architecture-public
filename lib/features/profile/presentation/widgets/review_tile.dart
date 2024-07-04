import 'package:flutter/material.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/widgets/rating_bar.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: comment.userProfileImageUrl != null
                ? NetworkImage(comment.userProfileImageUrl!)
                : null,
            child: comment.userProfileImageUrl == null
                ? Text(comment.userName.substring(0, 1))
                : null,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const RatingWidget(
                  initialRating: 3.5,
                  onRatingUpdate: null,
                  size: 20,
                  readOnly: true,
                ),
                Text(comment.text),
                // Text(
                //   formatDate(comment
                //       .timestamp), // Replace with your date formatting function
                //   style: const TextStyle(color: Colors.grey),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
