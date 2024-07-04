import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget(
      {super.key,
      required this.initialRating,
      required this.onRatingUpdate,
      this.size,
      this.readOnly = false});
  final double initialRating;
  final Function(double)? onRatingUpdate;
  final double? size;
  final bool readOnly;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: size ?? 40.0,
      ignoreGestures: readOnly,
      wrapAlignment: WrapAlignment.spaceEvenly,
      initialRating: initialRating,
      minRating: 1,
      maxRating: 5,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.only(right: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: onRatingUpdate ?? (value) {},
    );
  }
}
