import 'package:flutter/material.dart';

class DetailFormField extends StatelessWidget {
  const DetailFormField({
    super.key,
    required this.labelText,
    required this.currentValue,
  });

  final String labelText;
  final String currentValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      initialValue: currentValue,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
