import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/presentation/bloc/blood_donation_bloc.dart';
import 'package:myapp/features/blood_donations/presentation/pages/donation_guidelines_page.dart';
import 'package:myapp/features/settings/domain/entities/current_app_language.dart';
import 'package:myapp/features/settings/domain/entities/theme_mode.dart';
import 'package:myapp/features/settings/presentaion/cubit/current_app_language_cubit.dart';
import 'package:myapp/features/settings/presentaion/cubit/theme_mode_cubit.dart';
import 'package:myapp/features/settings/presentaion/widgets/settings_tile.dart';
import '../Data/settings_type_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = true;
  Donation? donation;
  @override
  void initState() {
    context.read<BloodDonationBloc>().add(MyBloodDonationsFetched());
    super.initState();
  }

  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    CurrentThemeMode currentThemeMode = context.watch<ThemeModeCubit>().state;
    CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    log(currentThemeMode.themeModeType.toString());
    final settingsTypeDataList =
        settingsTypeData(context, currentThemeMode, currentAppLanguage)
            .entries
            .toList();
    return BlocListener<BloodDonationBloc, BloodDonationState>(
      listener: (context, state) {
        if (state is MyBloodDonationsFetchedSuccess) {
          donation =
              context.read<BloodDonationBloc>().isDonor(state.myDonations);
          setState(() {
            isLoading = false;
          });
        }
        if (state is MyBloodDonationsFetchedFailure) {
          showSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.setting_appBar,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            !isLoading
                ? SwitchListTile(
                    value: donation != null,
                    onChanged: (value) {
                      if (donation == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const DonationGuidelinesPage(),
                        ));
                      } else {
                        context
                            .read<BloodDonationBloc>()
                            .add(BloodDonationTurnedOff(donation!));
                        Navigator.of(context).pop();
                      }
                    },
                    title: Row(
                      children: [
                        const Icon(Icons.bloodtype),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .settingsType_availableAsDonor,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: AspectRatio(
                          aspectRatio: 1, child: CircularProgressIndicator()),
                    ),
                  ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    settingsTypeDataList.length, // Assuming 4 settings for now
                itemBuilder: (context, index) {
                  final settingtype = settingsTypeDataList[index];
                  return SettingsTile(
                    title: settingtype.value.title,
                    icon: settingtype.value.icon,
                    subtitle: settingtype.value.subtitle,
                    onTap: settingtype.value.onTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showThemeDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Choose Theme'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             ListTile(
  //               title: const Text('Dark'),
  //               leading: Radio<bool>(
  //                 value: true,
  //                 groupValue: isDarkTheme,
  //                 onChanged: (bool? value) =>
  //                     setState(() => isDarkTheme = value!),
  //               ),
  //             ),
  //             ListTile(
  //               title: const Text('Light'),
  //               leading: Radio<bool>(
  //                 value: false,
  //                 groupValue: isDarkTheme,
  //                 onChanged: (bool? value) =>
  //                     setState(() => isDarkTheme = value!),
  //               ),
  //             ),
  //             ListTile(
  //               title: const Text('System Default'),
  //               leading: Radio<bool>(
  //                 value: true,
  //                 groupValue: isDarkTheme,
  //                 onChanged: (value) => Navigator.of(context).pop(),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
