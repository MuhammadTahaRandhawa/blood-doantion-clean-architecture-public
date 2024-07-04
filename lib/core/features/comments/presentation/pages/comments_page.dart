import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/features/comments/presentation/bloc/comments_bloc.dart';
import 'package:myapp/core/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final CommentType commentType;

  const CommentsPage(
      {super.key, required this.postId, required this.commentType});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _commentController = TextEditingController();
  // List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;
    final comments = context.watch<CommentCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.commentpage_comnt),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments
                  .length, // Replace with your comment data fetching logic
              itemBuilder: (context, index) {
                final comment = comments[index];
                return _buildCommentTile(comment);
              },
            ),
          ),
          _buildCommentInput(context, currentUser),
        ],
      ),
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

  Widget _buildCommentInput(BuildContext context, User currentUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context)!.commentpage_writecomment,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final comment = Comment(
                  commentType: widget.commentType,
                  userId: currentUser.userId,
                  userName: currentUser.userName,
                  userProfileImageUrl: currentUser.userProfileImageUrl,
                  text: _commentController.text,
                  timestamp: DateTime.now());
              context.read<CommentCubit>().addComment(comment);
              if (widget.commentType == CommentType.donation) {
                context
                    .read<CommentsBloc>()
                    .add(CommentOnDonationPosted(widget.postId, comment));
              }
              if (widget.commentType == CommentType.request) {
                context
                    .read<CommentsBloc>()
                    .add(CommentOnRequestPosted(widget.postId, comment));
              }

              _commentController.clear();
              //setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
