import 'package:flutter/material.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/utilis/date_formatter.dart';
import 'package:myapp/core/utilis/text_formatter.dart';
import 'package:myapp/features/profile/presentation/widgets/profile_info_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutUserToggle extends StatelessWidget {
  const AboutUserToggle({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileInfoWidget(
            title: AppLocalizations.of(context)!.userToggle_contactInfo,
            param1Label: AppLocalizations.of(context)!.userToggle_email,
            param1Value: user.email,
            param2Label: AppLocalizations.of(context)!.userToggle_phNo,
            param2Value: user.phoneNo),
        ProfileInfoWidget(
            title: AppLocalizations.of(context)!.userToggle_basicinfo,
            param1Label: AppLocalizations.of(context)!.userToggle_dob,
            param1Value: DateFormatter.formateDateToString(user.dob),
            param2Label: AppLocalizations.of(context)!.userToggle_gender,
            param2Value: user.gender),
        ProfileInfoWidget(
            title: AppLocalizations.of(context)!.userToggle_moreInfo,
            param1Label: AppLocalizations.of(context)!.userToggle_address,
            param1Value: TextFormatter.formatAddress(user.location.address),
            param2Label: AppLocalizations.of(context)!.userToggle_bGroup,
            param2Value: user.bloodGroup),
      ],
    );
  }
}
