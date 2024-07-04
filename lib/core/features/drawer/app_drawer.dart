import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/features/Faq/presentation/pages/faq_page.dart';
import 'package:myapp/features/in_app_tutorial/in_app_tutorial.dart';
import 'package:myapp/features/profile/presentation/pages/about_user_page.dart';
import 'package:myapp/features/settings/presentaion/pages/settings_page.dart';
import 'package:myapp/main.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;

    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColorLight
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: currentUser.userProfileImageUrl != null
                      ? SizedBox(
                          width:
                              100, // Set the desired width (adjust as needed)
                          height:
                              100, // Set the desired height (adjust as needed)
                          child: ClipOval(
                            child: Image.network(
                              currentUser.userProfileImageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  // Image is fully loaded, show the actual image
                                  return child;
                                } else {
                                  // Show a loading indicator (you can customize this widget)
                                  return CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  );
                                }
                              },
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            AppLocalizations.of(context)!.appDrawer_noImg,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(currentUser.userName),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.appDrawer_profile),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutUserPage(user: currentUser),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: Text(AppLocalizations.of(context)!.appDrawer_faq),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FaqPage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.appDrawer_setting),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_collection),
            title: Text(AppLocalizations.of(context)!.appDrawer_appTutorial),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const InAppTutorialPage(),
              ));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: Text(AppLocalizations.of(context)!.appDrawer_certificate),
          //   onTap: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => const CertificatePage(),
          //     ));
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.appDrawer_logOut),
            onTap: () => _showLogoutConfirmationDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.appDrawer_logOutfrom),
        content: Text(AppLocalizations.of(context)!.appDrawer_sureToLogout),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.appDrawer_no),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                        (route) => false,
                      ));
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(AppLocalizations.of(context)!.appDrawer_yes),
          ),
        ],
      ),
    );
  }
}
