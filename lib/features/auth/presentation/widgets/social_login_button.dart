import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton(
      {super.key,
      required this.icon,
      required this.color,
      required this.onPressed});
  final Widget icon;
  final Color color;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: onPressed,
      icon: icon,
      iconSize: 25,
      color: color,
    );
  }
}
