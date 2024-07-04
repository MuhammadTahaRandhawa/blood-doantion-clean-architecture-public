// import 'package:flutter/material.dart';
// import 'package:myapp/core/widgets/blood_group_filter.dart';
// import 'package:myapp/core/widgets/radius_filter.dart';

// class FilterMapPopUpButton extends StatefulWidget {
//   const FilterMapPopUpButton({
//     super.key,
//     required this.radius,
//     required this.bloodGroups,
//     required this.onChangedRadius,
//     required this.onChangedBloodGroups,
//   });

//   final int radius;
//   final List<String> bloodGroups;
//   final Function(int) onChangedRadius;
//   final Function(List<String>) onChangedBloodGroups;

//   @override
//   State<FilterMapPopUpButton> createState() => _FilterMapPopUpButtonState();
// }

// class _FilterMapPopUpButtonState extends State<FilterMapPopUpButton> {
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       itemBuilder: (context) => [
//         PopupMenuItem(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Search in Radius',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium!
//                     .copyWith(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 5),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: RadiusFilter(
//                   initialValue: widget.radius,
//                   onChanged: (p0) {
//                     print(p0);
//                     widget.onChangedRadius(p0);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const PopupMenuItem(child: PopupMenuDivider()),
//         PopupMenuItem(
//           child: Column(
//             children: [
//               Text(
//                 'Search Blood Group',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium!
//                     .copyWith(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: BloodGroupFilter(
//                   choosedList: widget.bloodGroups,
//                   onSelectGroup: (p0) {
//                     print(p0);
//                     widget.onChangedBloodGroups(p0);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//       icon: const Icon(Icons.filter_list),
//     );
//   }
// }
