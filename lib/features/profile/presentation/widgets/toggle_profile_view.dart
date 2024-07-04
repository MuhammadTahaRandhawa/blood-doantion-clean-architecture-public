import 'package:flutter/material.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/features/profile/presentation/widgets/about_user_toggle.dart';
import 'package:myapp/features/profile/presentation/widgets/reviews_toggle.dart';
import 'package:myapp/features/profile/presentation/widgets/toggle_profile_buttons.dart';
import 'package:myapp/features/profile/presentation/widgets/user_journey_toggle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToggleProfileView extends StatefulWidget {
  const ToggleProfileView({super.key, required this.user});

  final User user;

  @override
  State<ToggleProfileView> createState() => _ToggleProfileViewState();
}

class _ToggleProfileViewState extends State<ToggleProfileView> {
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleProfileButtons(
          user: widget.user,
          selectedTabIndex: tabIndex,
          onChangeTab: _onUpdateTabIndex,
        ),
        const SizedBox(
          height: 20,
        ),
        _toggleContent()
      ],
    );
  }

  _onUpdateTabIndex(int value) {
    setState(() {
      tabIndex = value;
    });
  }

  Widget _toggleContent() {
    switch (tabIndex) {
      case 0:
        return AboutUserToggle(user: widget.user);
      case 1:
        return UserJourneyToggle(
          user: widget.user,
        );
      case 2:
        return ReviewsToggle(
          user: widget.user,
        );

      default:
        return Center(
          child: Text(AppLocalizations.of(context)!.toggleProView_pageNotExist),
        );
    }
  }
}
