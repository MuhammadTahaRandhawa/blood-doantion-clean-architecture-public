import 'package:flutter/material.dart';

class GuidelineCheck extends StatefulWidget {
  const GuidelineCheck(
      {super.key,
      required this.head,
      required this.text,
      required this.checkValue,
      required this.onChanged});
  final String head;
  final String? text;
  final bool checkValue;
  final Function(bool) onChanged;

  @override
  State<GuidelineCheck> createState() => _GuidelineCheckState();
}

class _GuidelineCheckState extends State<GuidelineCheck> {
  late bool checkValue;
  @override
  void initState() {
    checkValue = widget.checkValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox.adaptive(
          shape: const CircleBorder(),
          value: checkValue,
          onChanged: (value) {
            if (value != null) {
              checkValue = value;
              widget.onChanged(value);
            }
          },
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: widget.text == null ? widget.head : '${widget.head}: ',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: widget.text,
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
