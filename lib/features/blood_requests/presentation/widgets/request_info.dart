import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/features/comments/presentation/bloc/comments_bloc.dart';
import 'package:myapp/core/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:myapp/core/features/comments/presentation/pages/comments_page.dart';
import 'package:myapp/core/features/rating/presentation/bloc/ratings_bloc.dart';
import 'package:myapp/core/features/rating/presentation/cubit/rating_cubit.dart';
import 'package:myapp/core/utilis/date_formatter.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestInfoWidget extends StatefulWidget {
  const RequestInfoWidget({super.key, required this.request});
  final Request request;

  @override
  State<RequestInfoWidget> createState() => _RequestInfoWidgetState();
}

class _RequestInfoWidgetState extends State<RequestInfoWidget> {
  double getRatingsAverage() {
    final ratings = context.watch<RatingCubit>().state;
    double total = 0.0;
    for (var rating in ratings) {
      total += rating.rating;
    }
    if (total == 0.0) {
      return 0.0;
    }
    double length = ratings.length.toDouble();

    return total / length;
  }

  @override
  initState() {
    context.read<CommentCubit>().emptyComments();
    context
        .read<CommentsBloc>()
        .add(CommentsOnRequestFetched(widget.request.requestId));
    context.read<RatingCubit>().emptyRatings();
    context
        .read<RatingsBloc>()
        .add(RatingsOnRequestFetched(widget.request.requestId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final comments = context.watch<CommentCubit>().state;
    final requestRatings = context.watch<RatingCubit>().state;
    return MultiBlocListener(
      listeners: [
        BlocListener<CommentsBloc, CommentsState>(
          listener: (context, state) {
            if (state is FetchCommentsFailure) {
              showSnackBar(context, state.message);
            }
            if (state is FetchCommentsSuccess) {
              context.read<CommentCubit>().initializeComments(state.comments);
            }
          },
        ),
        BlocListener<RatingsBloc, RatingsState>(
          listener: (context, state) {
            if (state is FetchRatingsFailure) {
              showSnackBar(context, state.message);
            }
            if (state is FetchRatingsSuccess) {
              context.read<RatingCubit>().initializeRatings(state.ratings);
            }
          },
        )
      ],
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    title: Text(
                      AppLocalizations.of(context)!.reqInfo_calculatedRating,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    content: Text(
                      AppLocalizations.of(context)!.reqInfo_ratingBased,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            Text(AppLocalizations.of(context)!.reqInfo_okBtn),
                      ),
                    ],
                  ),
                  barrierDismissible: true,
                );
              },
              child: _infoItem(
                context,
                title: '${getRatingsAverage()}',
                icon: Icons.star,
                subtitle: '${requestRatings.length}',
              ),
            ),
            _divider(),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentsPage(
                    commentType: CommentType.request,
                    postId: widget.request.requestId,
                  ),
                ));
              },
              child: _infoItem(
                context,
                icon: Icons.comment,
                subtitle: '${comments.length} comments',
              ),
            ),
            _divider(),
            _infoItem(
              context,
              icon: Icons.timelapse,
              subtitle: DateFormatter.findHowManyDaysAgo(
                  widget.request.requestDateTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => SizedBox(
        height: 24,
        child: VerticalDivider(
          color: Colors.grey[300],
          thickness: 1,
        ),
      );

  Widget _infoItem(BuildContext context,
      {String? title, required IconData icon, required String subtitle}) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: theme.primaryColor),
              ),
              const SizedBox(width: 4.0),
              Icon(icon, color: theme.primaryColor),
            ],
          ),
        if (title == null) Icon(icon, color: theme.primaryColor),
        const SizedBox(height: 8.0),
        Text(
          subtitle,
          style: theme.textTheme.titleSmall,
        ),
      ],
    );
  }
}
