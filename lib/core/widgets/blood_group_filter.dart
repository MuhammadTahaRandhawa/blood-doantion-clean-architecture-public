import 'package:flutter/material.dart';

class BloodGroupFilter extends StatefulWidget {
  const BloodGroupFilter({
    super.key,
    required this.onSelectGroup,
    required this.choosedList,
  });

  final Function(List<String>) onSelectGroup;
  final List<String> choosedList;

  @override
  State<BloodGroupFilter> createState() => _BloodGroupFilterState();
}

class _BloodGroupFilterState extends State<BloodGroupFilter> {
  final bloodGroupList = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  late List<String> choosedList;

  @override
  void initState() {
    super.initState();
    choosedList = widget.choosedList.isEmpty
        ? List.from(bloodGroupList)
        : widget.choosedList;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Reduced for better spacing
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2, // Adjusted for a wider view
      ),
      shrinkWrap: true,
      itemBuilder: (context, index) => ChoiceChip(
        label: Text(bloodGroupList[index]),
        selected: choosedList.contains(bloodGroupList[index]),
        onSelected: (selected) {
          setState(() {
            if (selected) {
              choosedList.add(bloodGroupList[index]);
            } else {
              choosedList.remove(bloodGroupList[index]);
            }
            widget.onSelectGroup(choosedList);
          });
        },
        selectedColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(
          color: choosedList.contains(bloodGroupList[index])
              ? Colors.white
              : Colors.black87,
        ),
      ),
      itemCount: bloodGroupList.length,
    );
  }
}
