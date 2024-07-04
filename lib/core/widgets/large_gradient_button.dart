import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_pallete.dart';

class LargeGradientButton extends StatelessWidget {
  const LargeGradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.isDisabled = false,
  });

  final VoidCallback onPressed;
  final double? width;
  final Widget child;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: AppPallete.gradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Adjust the opacity based on the isDisabled property
          color: isDisabled ? Colors.grey.withOpacity(0.6) : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: isDisabled ? null : onPressed,
            // Change the cursor to indicate disabled state
            mouseCursor: isDisabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
