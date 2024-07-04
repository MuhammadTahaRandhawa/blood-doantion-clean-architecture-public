import 'package:flutter/material.dart';

class SelectBloodGroup extends StatefulWidget {
  const SelectBloodGroup({Key? key, required this.onChanged, this.initialValue})
      : super(key: key);

  final Function(String) onChanged;
  final String? initialValue;

  @override
  State<SelectBloodGroup> createState() => _SelectBloodGroupState();
}

class _SelectBloodGroupState extends State<SelectBloodGroup> {
  final bloodGroupList = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String value = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      value = widget.initialValue!;
      widget.onChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary; // Use primary color

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: bloodGroupList.length,
        itemBuilder: (context, index) {
          final bloodGroup = bloodGroupList[index];
          final isSelected = bloodGroup == value;

          return InkWell(
            onTap: () {
              setState(() {
                value = bloodGroup;
                widget.onChanged(value);
              });
            },
            child: CircleAvatar(
              backgroundColor: isSelected ? selectedColor : null,
              radius: 20,
              child: Text(
                bloodGroup,
                style: TextStyle(
                  color:
                      isSelected ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
