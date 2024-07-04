import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToggleProfileButtons extends StatefulWidget {
  const ToggleProfileButtons(
      {super.key,
      required this.selectedTabIndex,
      required this.onChangeTab,
      required this.user});

  final int selectedTabIndex;
  final Function(int) onChangeTab;
  final User user;

  @override
  State<ToggleProfileButtons> createState() => _ToggleProfileButtonsState();
}

class _ToggleProfileButtonsState extends State<ToggleProfileButtons> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserCubit>().state;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.selectedTabIndex == 0
              ? ElevatedButton(
                  onPressed: () {
                    widget.onChangeTab(0);
                  },
                  child: widget.user.userId == currentUser.userId
                      ? Text(
                          AppLocalizations.of(context)!.toggleprofile_about_me)
                      : Text(AppLocalizations.of(context)!
                          .toggleprofile_about_user),
                )
              : TextButton(
                  onPressed: () {
                    widget.onChangeTab(0);
                  },
                  child: Text(
                    widget.user.userId == currentUser.userId
                        ? AppLocalizations.of(context)!.toggleprofile_about_me
                        : AppLocalizations.of(context)!
                            .toggleprofile_about_user,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer),
                  ),
                ),
          if (currentUser.userId == widget.user.userId)
            widget.selectedTabIndex == 1
                ? ElevatedButton(
                    onPressed: () {
                      widget.onChangeTab(1);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .toggleprofile_userJourney),
                  )
                : TextButton(
                    onPressed: () {
                      widget.onChangeTab(1);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.toggleprofile_userJourney,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                  ),
          widget.selectedTabIndex == 2
              ? ElevatedButton(
                  onPressed: () {
                    widget.onChangeTab(2);
                  },
                  child:
                      Text(AppLocalizations.of(context)!.toggleprofile_reviews),
                )
              : TextButton(
                  onPressed: () {
                    widget.onChangeTab(2);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.toggleprofile_reviews,
                    style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer),
                  ),
                )
        ],
      ),
    );
  }
}
