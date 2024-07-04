import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodCardShimmer extends StatelessWidget {
  const BloodCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(children: [
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const CircleAvatar(radius: 40),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Text(AppLocalizations.of(context)!.bloodShimmer_loading,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Text(AppLocalizations.of(context)!.bloodShimmer_plzWait,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 10),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: const SizedBox(
                  height: 20,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const CircleAvatar(),
          ),
        ),
        const SizedBox(width: 10),
      ]),
    );
  }
}
