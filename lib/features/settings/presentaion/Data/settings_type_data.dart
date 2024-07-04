import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/features/settings/domain/entities/current_app_language.dart';
import 'package:myapp/features/settings/domain/entities/theme_mode.dart';
import 'package:myapp/features/settings/presentaion/cubit/current_app_language_cubit.dart';
import 'package:myapp/features/settings/presentaion/cubit/theme_mode_cubit.dart';

enum SettingsTypes { notifications, theme, appLangauge, contactUs }

class SettingData {
  String title;
  Icon icon;
  VoidCallback onTap;
  String? subtitle;

  SettingData(
      {required this.icon,
      required this.onTap,
      required this.title,
      this.subtitle});
}

Map<SettingsTypes, SettingData> settingsTypeData(BuildContext context,
    CurrentThemeMode currentThemeMode, CurrentAppLanguage currentAppLanguage) {
  Map<SettingsTypes, SettingData> settingsTypeData = {
    // SettingsTypes.notifications: SettingData(
    //     title: AppLocalizations.of(context)!.settingsType_notifcation,
    //     icon: const Icon(Icons.notifications),
    //     subtitle: AppLocalizations.of(context)!.settingsType_msgAppointment,
    //     onTap: () {
    //       Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => const NotificationSettingsPage(),
    //       ));
    //     }),
    SettingsTypes.theme: SettingData(
        icon: const Icon(Icons.color_lens),
        onTap: () {
          _onPressedThemeChange(context, currentThemeMode);
        },
        title: AppLocalizations.of(context)!.settingsType_theme),
    SettingsTypes.appLangauge: SettingData(
        icon: const Icon(Icons.language),
        onTap: () {
          _onPressedChangeAppLanguage(context, currentAppLanguage);
        },
        title: AppLocalizations.of(context)!.settingsType_appLanguage),
    // SettingsTypes.contactUs: SettingData(
    //     icon: const Icon(Icons.mail),
    //     onTap: () {},
    //     title: AppLocalizations.of(context)!.settingsType_contactUs)
  };
  return settingsTypeData;
}

_onPressedThemeChange(BuildContext context, CurrentThemeMode currentThemeMode) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.settingsType_chooseTheme,
          style: const TextStyle()
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioListTile(
                title: Text(AppLocalizations.of(context)!.settingsType_light),
                selected: currentThemeMode.themeModeType == ThemeModeType.light,
                value: ThemeModeType.light,
                groupValue: currentThemeMode.themeModeType,
                onChanged: (value) {
                  context.read<ThemeModeCubit>().setTheme(ThemeModeType.light);
                  _pop(context);
                }),
            RadioListTile(
                title: Text(AppLocalizations.of(context)!.settingsType_dark),
                selected: currentThemeMode.themeModeType == ThemeModeType.dark,
                value: ThemeModeType.dark,
                groupValue: currentThemeMode.themeModeType,
                onChanged: (value) {
                  context.read<ThemeModeCubit>().setTheme(ThemeModeType.dark);
                  _pop(context);
                }),
            RadioListTile(
                title: Text(
                    AppLocalizations.of(context)!.settingsType_deviceTheme),
                selected: currentThemeMode.themeModeType ==
                    ThemeModeType.deviceCurrent,
                value: ThemeModeType.deviceCurrent,
                groupValue: currentThemeMode.themeModeType,
                onChanged: (value) {
                  context
                      .read<ThemeModeCubit>()
                      .setTheme(ThemeModeType.deviceCurrent);
                  _pop(context);
                }),
          ],
        ),
      );
    },
  );
}

_onPressedChangeAppLanguage(
    BuildContext context, CurrentAppLanguage currentAppLanguage) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.settingsType_chooseAppLanguage,
          style: const TextStyle()
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioListTile(
                title: Text(AppLocalizations.of(context)!.settingsType_english),
                selected: currentAppLanguage.currentAppLanguageType ==
                    AppLanguageType.english,
                value: AppLanguageType.english,
                groupValue: currentAppLanguage.currentAppLanguageType,
                onChanged: (value) {
                  context
                      .read<CurrentAppLanguageCubit>()
                      .setLanguage(AppLanguageType.english);
                  _pop(context);
                }),
            RadioListTile(
                title: Text(AppLocalizations.of(context)!.settingsType_urdu),
                selected: currentAppLanguage.currentAppLanguageType ==
                    AppLanguageType.urdu,
                value: AppLanguageType.urdu,
                groupValue: currentAppLanguage.currentAppLanguageType,
                onChanged: (value) {
                  context
                      .read<CurrentAppLanguageCubit>()
                      .setLanguage(AppLanguageType.urdu);
                  _pop(context);
                }),
          ],
        ),
      );
    },
  );
}

void _pop(BuildContext context) {
  Navigator.of(context).pop();
}
