import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:shimmer/shimmer.dart';

class ChatCardShimmer extends StatelessWidget {
  const ChatCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Shimmer.fromColors(
        baseColor: AppPallete.shimmerBasicColor,
        highlightColor: AppPallete.shimmerHighlightCOlor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppPallete.shimmerBasicColor,
                radius: 24,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: AppPallete.shimmerBasicColor,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: AppPallete.shimmerBasicColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: 16.0,
                    color: AppPallete.shimmerBasicColor,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: 24,
                    height: 16.0,
                    color: AppPallete.shimmerBasicColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
