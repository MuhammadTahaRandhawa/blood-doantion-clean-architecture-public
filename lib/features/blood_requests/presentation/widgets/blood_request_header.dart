import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/core/widgets/blood_filter_bottom_sheet.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/presentation/pages/my_blood_requests_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodRequestHeader extends StatelessWidget {
  const BloodRequestHeader(
      {super.key,
      required this.filteredRequests,
      required this.bloodGroups,
      required this.onChangedBloodGroups,
      required this.onChangedRadius,
      required this.radius});

  final List<Request> filteredRequests;
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
              end: Alignment.centerRight,
            ),
          ),
        ),
        Positioned(
          top: notchHeight,
          right: 20,
          child: BloodFilterIconBottomSheet(
            bloodGroups: bloodGroups,
            initialRadius: radius,
            onChangedBloodGroups: onChangedBloodGroups,
            onChangedRadius: onChangedRadius,
          ),
        ),
        Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppPallete.shimmerBasicColor,
                    highlightColor: AppPallete.shimmerHighlightCOlor,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        text: '${filteredRequests.length}\n',
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!
                                .bloodReqheader_newReq,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyBloodRequestsPage(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                        AppLocalizations.of(context)!.bloodReqheader_myReq,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
