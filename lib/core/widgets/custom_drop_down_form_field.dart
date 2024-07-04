import 'package:flutter/material.dart';

class CustomDropDownFormField extends StatefulWidget {
  const CustomDropDownFormField(
      {super.key,
      required this.data,
      this.icon,
      this.hintText,
      required this.onChanged});

  final List data;
  final Icon? icon;
  final String? hintText;
  final void Function(Object?)? onChanged;

  @override
  State<CustomDropDownFormField> createState() =>
      _CustomDropDownFormFieldState();
}

class _CustomDropDownFormFieldState extends State<CustomDropDownFormField> {
  String objectToString(Object object) {
    return object.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: widget.data
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  objectToString(e),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ))
          .toList(),
      style: Theme.of(context).textTheme.titleMedium,
      onChanged: widget.onChanged,
      value: widget.data.first,
      decoration: InputDecoration(
          prefixIcon: widget.icon,
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.titleLarge,
          filled: true,
          fillColor: Theme.of(context).colorScheme.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[350]!),
          )),
    );
  }
}
