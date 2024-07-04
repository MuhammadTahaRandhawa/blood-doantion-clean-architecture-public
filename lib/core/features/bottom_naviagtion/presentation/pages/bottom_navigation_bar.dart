import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/cubit/bottom_navigation_bar_index_cubit.dart';
import 'package:myapp/features/blood_centers/presentation/pages/blood_centers_page.dart';
import 'package:myapp/features/blood_donations/presentation/pages/blood_donations_page.dart';
import 'package:myapp/features/blood_map/presentation/pages/blood_map_page.dart';
import 'package:myapp/features/blood_requests/presentation/pages/blood_requests_page.dart';
import 'package:myapp/features/home/presentaion/pages/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({super.key});

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<BottomNavigationBarIndexCubit>().state;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _pageController.jumpToPage(currentIndex);
      },
    );

    // final tabs = [
    //   BottomNavigationBarItem(
    //       icon: Icon(CupertinoIcons.home),
    //       label: AppLocalizations.of(context)!.bottmnav_home),
    //   BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.bloodtype_outlined,
    //         size: 25,
    //       ),
    //       label: AppLocalizations.of(context)!.bottmnav_request),
    //   BottomNavigationBarItem(
    //       icon: Icon(
    //         CupertinoIcons.heart,
    //         size: 25,
    //       ),
    //       label: AppLocalizations.of(context)!.bottmnav_donation),
    //   BottomNavigationBarItem(
    //       icon: Icon(Icons.apartment),
    //       label: AppLocalizations.of(context)!.bottmnav_center),
    //   BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.location_on_outlined,
    //         size: 25,
    //       ),
    //       label: AppLocalizations.of(context)!.bottmnav_map)
    // ];

    onTap(value) {
      if (currentIndex != value) {
        _pageController.jumpToPage(value);
      }
      context.read<BottomNavigationBarIndexCubit>().updateIndex(value);
    }

    return Scaffold(
      body: PageView(
        physics: currentIndex == 4
            ? const NeverScrollableScrollPhysics()
            : const ScrollPhysics(),
        controller: _pageController,
        onPageChanged: onTap,
        children: const [
          HomePage(),
          BloodRequestsPage(),
          BloodDonationPage(),
          BloodCentersPage(),
          BloodMapPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: currentIndex != 0
                ? const Icon(CupertinoIcons.home)
                : const Icon(CupertinoIcons.house_fill),
            label: AppLocalizations.of(context)!.bottmnav_home,
            tooltip: AppLocalizations.of(context)!.bottmnav_home,
          ),
          BottomNavigationBarItem(
              icon: currentIndex != 1
                  ? const Icon(
                      Icons.bloodtype_outlined,
                      size: 25,
                    )
                  : const Icon(
                      Icons.bloodtype,
                      size: 25,
                    ),
              label: AppLocalizations.of(context)!.bottmnav_request,
              tooltip: AppLocalizations.of(context)!.bottmnav_request),
          BottomNavigationBarItem(
              icon: currentIndex != 2
                  ? const Icon(
                      CupertinoIcons.heart,
                      size: 25,
                    )
                  : const Icon(
                      CupertinoIcons.heart_fill,
                      size: 25,
                    ),
              label: AppLocalizations.of(context)!.bottmnav_donation,
              tooltip: AppLocalizations.of(context)!.bottmnav_donation),
          BottomNavigationBarItem(
              icon: currentIndex != 3
                  ? const Icon(
                      Icons.apartment,
                      size: 25,
                    )
                  : const Icon(
                      Icons.apartment,
                      size: 25,
                    ),
              label: AppLocalizations.of(context)!.bottmnav_center,
              tooltip: AppLocalizations.of(context)!.bottmnav_center),
          BottomNavigationBarItem(
              icon: currentIndex != 4
                  ? const Icon(
                      Icons.location_on_outlined,
                      size: 25,
                    )
                  : const Icon(
                      Icons.location_on,
                      size: 25,
                    ),
              label: AppLocalizations.of(context)!.bottmnav_map,
              tooltip: AppLocalizations.of(context)!.bottmnav_bloodMap)
        ],
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
