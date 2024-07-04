import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationSettingTile extends StatelessWidget {
  const NotificationSettingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: true,
      onChanged: (value) {},
      title: Text(AppLocalizations.of(context)!.notSettingTile_notifcation),
    );
  }
}
