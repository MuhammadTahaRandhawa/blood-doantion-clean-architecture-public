import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodCenterHeader extends StatelessWidget {
  const BloodCenterHeader({
    super.key,
    required this.bloodCenters,
  });

  final List<BloodCenter> bloodCenters;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
          bottom: 50,
          left: 20,
          right: 20,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Shimmer.fromColors(
                  baseColor: AppPallete.shimmerBasicColor,
                  highlightColor: AppPallete.shimmerHighlightCOlor,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                      text: '${bloodCenters.length}\n',
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .bloodHeader_bloodCenter,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
