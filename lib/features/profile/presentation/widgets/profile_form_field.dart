import 'package:flutter/material.dart';

class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    super.key,
    required this.labelText,
    //required this.currentValue,
    required this.validator,
    required this.controller,
    this.readOnly = false,
  });

  final String labelText;
  //final String currentValue;
  final Function(String? value) validator;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      //initialValue: currentValue,
      style: Theme.of(context).textTheme.titleMedium,
      validator: (value) => validator(value),
      decoration: InputDecoration(
        labelText: labelText,
        // labelStyle: TextStyle(
        //   color: Theme.of(context).primaryColor,
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
