import 'package:flutter/material.dart';
import 'package:myapp/features/settings/presentaion/widgets/notification_setting_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notSetting_appBar),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => const NotificationSettingTile(),
        itemCount: 4,
      ),
    );
  }
}
