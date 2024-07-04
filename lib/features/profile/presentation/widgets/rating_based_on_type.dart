import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RatingBasedOnType extends StatelessWidget {
  const RatingBasedOnType({
    super.key,
    required this.label,
    required this.rating,
  });

  final String label;
  final double rating;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final boxWidth = (width / 4) * 3;
    return Row(
      children: [
        Expanded(flex: 1, child: Text(label)),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 12,
            decoration: const BoxDecoration(color: Color(0XFFE8E8E8)),
            alignment: Alignment.centerLeft,
            child: Container(
              height: 12,
              color: _getColor(rating),
              width: _getRatingWidth(rating, boxWidth),
            ),
          ),
        )
      ],
    );
  }

  double _getRatingWidth(double rating, double boxWidth) {
    if (rating >= 4.5 && rating <= 5.0) {
      return boxWidth;
    } else if (rating >= 3.5 && rating < 4.5) {
      return (boxWidth / 5) * 4;
    } else if (rating >= 2.5 && rating < 3.5) {
      return (boxWidth / 5) * 3;
    } else if (rating >= 1.5 && rating < 2.5) {
      return (boxWidth / 5) * 2;
    } else {
      return (boxWidth / 5) * 1;
    }
  }

  Color _getColor(double rating) {
    if (rating >= 4.5 && rating <= 5.0) {
      return const Color(0XFF004600);
    } else if (rating >= 3.5 && rating < 4.5) {
      return const Color(0XFFa1c212);
    } else if (rating >= 2.5 && rating < 3.5) {
      return const Color(0XFFf9e432);
    } else if (rating >= 1.5 && rating < 2.5) {
      return const Color(0XFFd07200);
    } else {
      return const Color(0XFFc70f0f);
    }
  }
}
