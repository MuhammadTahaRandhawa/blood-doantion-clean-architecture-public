import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectGender extends StatefulWidget {
  const SelectGender({super.key, required this.onChanged, this.initialValue});

  final Function(bool) onChanged;
  final bool? initialValue;

  @override
  State<SelectGender> createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  bool? value;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      value = widget.initialValue;
      widget.onChanged(value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGenderButton(
            icon: Icons.boy,
            label: AppLocalizations.of(context)!.selectGender_male,
            isSelected: value == true,
            onPressed: () {
              setState(() {
                value = true;
                widget.onChanged(value!);
              });
            },
          ),
          const SizedBox(width: 20), // Adjusted spacing
          VerticalDivider(
            color: Colors.grey.shade200, // Neutral divider color
            thickness: 1, // Increased thickness for better visibility
          ),
          const SizedBox(width: 20), // Adjusted spacing
          _buildGenderButton(
            icon: Icons.girl,
            label: AppLocalizations.of(context)!.selectGender_female,
            isSelected: value == false,
            onPressed: () {
              setState(() {
                value = false;
                widget.onChanged(value!);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          child: TextButton.icon(
            onPressed: onPressed,
            icon: Icon(icon,
                size: 30,
                color: isSelected
                    ? Colors.white
                    : Colors.grey), // Consistent color scheme
            label: Text(
              label,
              style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.grey), // Consistent color scheme
            ),
          ),
        ),
      ],
    );
  }
}
