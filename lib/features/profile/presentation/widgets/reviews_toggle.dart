import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/comments/domain/entities/comment.dart';
import 'package:myapp/core/features/comments/presentation/bloc/comments_bloc.dart';
import 'package:myapp/core/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';
import 'package:myapp/core/features/rating/presentation/bloc/ratings_bloc.dart';
import 'package:myapp/core/features/rating/presentation/cubit/rating_cubit.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/rating_bar.dart';
import 'package:myapp/features/profile/presentation/widgets/review_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewsToggle extends StatefulWidget {
  const ReviewsToggle({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<ReviewsToggle> createState() => _ReviewsToggleState();
}

class _ReviewsToggleState extends State<ReviewsToggle> {
  @override
  void initState() {
    context.read<CommentCubit>().emptyComments();
    context
        .read<RatingsBloc>()
        .add(RatingsOnDonationFetched(widget.user.userId));
    context.read<RatingCubit>().emptyRatings();
    context
        .read<CommentsBloc>()
        .add(CommentsOnDonationFetched(widget.user.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Rating> ratings = context.watch<RatingCubit>().state;
    final comments = context.watch<CommentCubit>().state;
    return MultiBlocListener(
      listeners: [
        BlocListener<CommentsBloc, CommentsState>(
          listener: (context, state) {
            if (state is FetchCommentsSuccess) {
              context.read<CommentCubit>().initializeComments(state.comments);
            }
            if (state is FetchCommentsFailure) {
              showSnackBar(context, state.message);
            }
          },
        ),
        BlocListener<RatingsBloc, RatingsState>(
          listener: (context, state) {
            if (state is FetchRatingsSuccess) {
              context.read<RatingCubit>().initializeRatings(state.ratings);
            }
            if (state is FetchRatingsFailure) {
              showSnackBar(context, state.message);
            }
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.reviewToggle_allRating,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${context.read<RatingCubit>().getRatingsAverage(ratings)}',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const RatingWidget(
            initialRating: 0.0,
            onRatingUpdate: null,
            readOnly: true,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
              '${AppLocalizations.of(context)!.reviewToggle_baseOn} ${ratings.length} ${AppLocalizations.of(context)!.reviewToggle_reviews}'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.reviewToggle_reviews,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            height: 500,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  ReviewTile(comment: comments[index]),
              itemCount: comments.length,
            ),
          ),
        ],
      ),
    );
  }
}
