import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:myapp/features/auth/presentation/helpers/conatiner_custom_clippers.dart';

class BelowCurvedContainer extends StatelessWidget {
  const BelowCurvedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: ConatinerCustomClipPath(),
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ClipPath(
              clipper: ConatinerCustomClipPath(),
              child: Image.asset(
                kIsWeb
                    ? 'images/hands_login.png'
                    : 'assets/images/hands_login.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
