import 'package:flutter/material.dart';

import 'package:myapp/core/theme/app_pallete.dart';

class MovingDot extends StatelessWidget {
  const MovingDot({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSelected ? 15 : 10,
      width: isSelected ? 15 : 10,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: isSelected
                  ? AppPallete.gradientColor
                  : [Colors.grey, Colors.grey])),
    );
  }
}
