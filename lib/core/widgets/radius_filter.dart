import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RadiusFilter extends StatefulWidget {
  const RadiusFilter({
    super.key,
    required this.onChanged,
    required this.initialValue,
  });

  final Function(int) onChanged;
  final int initialValue;

  @override
  State<RadiusFilter> createState() => _RadiusFilterState();
}

class _RadiusFilterState extends State<RadiusFilter> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            '${AppLocalizations.of(context)!.radiusfilter_selectRadius} $selectedValue ${AppLocalizations.of(context)!.radiusfilter_km}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Slider(
          value: selectedValue.toDouble(),
          min: 4,
          max: 32,
          divisions: 7,
          label:
              '$selectedValue ${AppLocalizations.of(context)!.radiusfilter_km}',
          onChanged: (double newValue) {
            setState(() {
              selectedValue = newValue.round();
            });
            widget.onChanged(selectedValue);
          },
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );
  }
}
