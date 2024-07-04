import 'package:flutter/material.dart';

class AuthButton extends StatefulWidget {
  const AuthButton(
      {super.key,
      required this.child,
      required this.isLoading,
      required this.onPressed});

  final Widget child;
  final bool isLoading;
  final VoidCallback onPressed;
  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: !widget.isLoading ? widget.onPressed : null,
        style: FilledButton.styleFrom(
            fixedSize: const Size(100, 50),
            alignment: Alignment.center,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            side: const BorderSide(
                style: BorderStyle.solid, width: 1, color: Colors.transparent)),
        child: !widget.isLoading
            ? widget.child
            : const AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator.adaptive(),
              ));
  }
}
