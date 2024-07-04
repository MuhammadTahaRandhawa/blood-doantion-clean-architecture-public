import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestLocationMapImageInputContainer extends StatelessWidget {
  const RequestLocationMapImageInputContainer({
    super.key,
    required this.mapsImage,
    this.height = 200,
    required this.onPressedChooseCurrentLocation,
    required this.onPressedChooseLocationOnMap,
  });

  final Widget? mapsImage;
  final double height;
  final VoidCallback onPressedChooseCurrentLocation;
  final VoidCallback onPressedChooseLocationOnMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Rounded corners
        border: Border.all(
          color: Theme.of(context).colorScheme.outline, // Use theme color
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          if (mapsImage != null)
            mapsImage! // Display the map image if provided
          else
            Center(
              child: Text(
                AppLocalizations.of(context)!.reqLocInputMap_chooseloc,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.grey[400], // Faded text for placeholder
                    ),
              ),
            ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: 'select current location hero',
                  onPressed: onPressedChooseCurrentLocation,
                  mini: true, // Smaller floating action button
                  child:
                      const Icon(Icons.location_on_outlined), // Location icon
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  heroTag: 'select on map hero',
                  onPressed: onPressedChooseLocationOnMap,
                  mini: true, // Smaller floating action button
                  child: const Icon(CupertinoIcons.map), // Location icon
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
