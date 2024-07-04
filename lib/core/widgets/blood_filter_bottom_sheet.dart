import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/blood_group_filter.dart';
import 'package:myapp/core/widgets/radius_filter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodFilterIconBottomSheet extends StatefulWidget {
  const BloodFilterIconBottomSheet(
      {super.key,
      required this.onChangedRadius,
      required this.onChangedBloodGroups,
      required this.initialRadius,
      required this.bloodGroups,
      this.iconColor = Colors.white});

  final Function(int) onChangedRadius;
  final Function(List<String>) onChangedBloodGroups;
  final int initialRadius;
  final List<String> bloodGroups;
  final Color iconColor;

  @override
  State<BloodFilterIconBottomSheet> createState() =>
      _BloodFilterIconBottomSheetState();
}

class _BloodFilterIconBottomSheetState
    extends State<BloodFilterIconBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              FilterSection(
                // icon: CupertinoIcons.location_solid,
                title: AppLocalizations.of(context)!.bloodFilter_searchInside,
                child: RadiusFilter(
                  initialValue: widget.initialRadius,
                  onChanged: widget.onChangedRadius,
                ),
              ),
              const Divider(),
              FilterSection(
                // icon: Icons.bloodtype,
                title: AppLocalizations.of(context)!.bloodFilter_searchBlood,
                child: BloodGroupFilter(
                  choosedList: widget.bloodGroups,
                  onSelectGroup: widget.onChangedBloodGroups,
                ),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        isScrollControlled: true,
      ),
      icon: Icon(
        Icons.filter_list,
        color: widget.iconColor,
      ),
    );
  }
}

class FilterSection extends StatelessWidget {
  const FilterSection({
    super.key,
    // required this.icon,
    required this.title,
    required this.child,
  });

  // final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
