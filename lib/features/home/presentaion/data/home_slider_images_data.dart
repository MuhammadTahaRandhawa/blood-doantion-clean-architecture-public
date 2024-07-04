import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/cubit/bottom_navigation_bar_index_cubit.dart';
import 'package:myapp/features/in_app_tutorial/in_app_tutorial.dart';

class SliderDataModel {
  final Image image;
  final VoidCallback onPressed;

  SliderDataModel({required this.image, required this.onPressed});
}

List<SliderDataModel> homeSliderData(BuildContext context) => [
      SliderDataModel(
        image: Image.asset(kIsWeb
            ? 'images/home_slider/blood_map.png'
            : 'assets/images/home_slider/blood_map.png'),
        onPressed: () {
          context.read<BottomNavigationBarIndexCubit>().updateIndex(4);
        },
      ),
      SliderDataModel(
        image: Image.asset(kIsWeb
            ? 'images/home_slider/blood_request.png'
            : 'assets/images/home_slider/blood_request.png'),
        onPressed: () {
          context.read<BottomNavigationBarIndexCubit>().updateIndex(1);
        },
      ),
      SliderDataModel(
        image: Image.asset(kIsWeb
            ? 'images/home_slider/centers.png'
            : 'assets/images/home_slider/centers.png'),
        onPressed: () {
          context.read<BottomNavigationBarIndexCubit>().updateIndex(3);
        },
      ),
      SliderDataModel(
        image: Image.asset(kIsWeb
            ? 'images/home_slider/donate_blood.png'
            : 'assets/images/home_slider/donate_blood.png'),
        onPressed: () {
          context.read<BottomNavigationBarIndexCubit>().updateIndex(2);
        },
      ),
      SliderDataModel(
        image: Image.asset(kIsWeb
            ? 'images/home_slider/in_app_tutorial.png'
            : 'assets/images/home_slider/in_app_tutorial.png'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const InAppTutorialPage(),
          ));
        },
      ),
    ];
