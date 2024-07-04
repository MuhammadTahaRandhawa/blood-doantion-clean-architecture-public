import 'package:flutter/material.dart';

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget(
      {super.key,
      required this.title,
      required this.param1Label,
      required this.param1Value,
      required this.param2Label,
      required this.param2Value});

  final String title;
  final String param1Label;
  final String param1Value;
  final String param2Label;
  final String param2Value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                param1Label,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                param1Value,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.error),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                param2Label,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                param2Value,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.error),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider()
      ],
    );
  }
}
