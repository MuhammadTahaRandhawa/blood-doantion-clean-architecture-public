import 'package:flutter/material.dart';
import 'package:myapp/core/theme/app_pallete.dart';

class UnreadMessagesContainer extends StatelessWidget {
  const UnreadMessagesContainer(
      {super.key, required this.numberOfUnreadMessages});

  final int numberOfUnreadMessages;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: AppPallete.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          numberOfUnreadMessages.toString(),
          style: const TextStyle()
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
