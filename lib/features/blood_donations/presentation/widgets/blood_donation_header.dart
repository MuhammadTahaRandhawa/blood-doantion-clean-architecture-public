import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/core/widgets/blood_filter_bottom_sheet.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodDonationHeader extends StatelessWidget {
  const BloodDonationHeader(
      {super.key,
      required this.filteredDonations,
      required this.bloodGroups,
      required this.onChangedBloodGroups,
      required this.radius,
      required this.onChangedRadius});

  final List<Donation> filteredDonations;
  final List<String> bloodGroups;
  final Function(List<String>) onChangedBloodGroups;
  final Function(int) onChangedRadius;
  final int radius;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final notchHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        Container(
          width: width,
          height: MediaQuery.of(context).size.height / 2.7,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: AppPallete.gradientColor,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
        ),
        Positioned(
          bottom: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 120,
              width: width - 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: Colors.white),
                        text: '${filteredDonations.length}\n',
                        children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .bloodDonationHeader_donorAvailable,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(color: Colors.white))
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: notchHeight,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: width - 60,
                ),
                BloodFilterIconBottomSheet(
                  bloodGroups: bloodGroups,
                  initialRadius: radius,
                  onChangedBloodGroups: (p0) => onChangedBloodGroups(p0),
                  onChangedRadius: (p0) => onChangedRadius(p0),
                ),
              ]),
          //top: 0,
        ),
      ],
    );
  }
}
