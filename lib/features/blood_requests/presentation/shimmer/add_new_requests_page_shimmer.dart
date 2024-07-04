// import 'package:flutter/material.dart';
// import 'package:myapp/core/widgets/custom_text_form_field.dart';
// import 'package:shimmer/shimmer.dart';

// class AddNewRequestPageShimmer extends StatelessWidget {
//   const AddNewRequestPageShimmer({super.key});

//   final Widget formField = CustomTextFormField(
//     hintText: 'Full Name',
//     validator: (value) {},
//     icon: const Icon(Icons.person),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Request'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Form(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Shimmer.fromColors(
//                   baseColor: Colors.grey[300]!,
//                   highlightColor: Colors.grey[100]!,
//                   child: formField,
//                 ),
//                 const SizedBox(height: 20),
//                 Shimmer.fromColors(
//                   baseColor: Colors.grey[300]!,
//                   highlightColor: Colors.grey[100]!,
//                   child: formField,
//                 ),
//                 const SizedBox(height: 20),
//                 Shimmer.fromColors(
//                   baseColor: Colors.grey[300]!,
//                   highlightColor: Colors.grey[100]!,
//                   child: formField,
//                 ),
//                 const SizedBox(height: 20),
//                 Shimmer.fromColors(
//                   baseColor: Colors.grey[300]!,
//                   highlightColor: Colors.grey[100]!,
//                   child: formField,
//                 ),
//                 const SizedBox(height: 20),
//                 Shimmer.fromColors(
//                   baseColor: Colors.grey[300]!,
//                   highlightColor: Colors.grey[100]!,
//                   child: const SelectBloodGroup(),
//                 ),
//                 const SizedBox(height: 10),
//                 Shimmer.fromColors(
//                   baseColor: Colors.grey[300]!,
//                   highlightColor: Colors.grey[100]!,
//                   child: const RequestLocationMapImageInputContainer(),
//                 ),
//                 const SizedBox(height: 10),
//                 const SizedBox(height: 30),
//                 const Placeholder(child: LargeGradientButton()),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
