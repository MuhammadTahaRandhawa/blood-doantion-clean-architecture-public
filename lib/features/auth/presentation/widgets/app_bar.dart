import 'package:flutter/material.dart';
import 'package:myapp/features/auth/presentation/widgets/below_curved_container.dart';

class AuthAppBar extends StatelessWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const BelowCurvedContainer(),
      Positioned(
        left: 5,
        top: MediaQuery.of(context).padding.top + 10,
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 40,
          ),
        ),
      )
    ]);
  }
}
