import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/widgets/moving_dot.dart';
import 'package:myapp/features/home/presentaion/data/home_slider_images_data.dart';
import 'package:myapp/features/splash/presentaion/consts/slider_images.dart';

class HomeTopWidget extends StatefulWidget {
  const HomeTopWidget({super.key});

  @override
  State<HomeTopWidget> createState() => _HomeTopWidgetState();
}

class _HomeTopWidgetState extends State<HomeTopWidget> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final sliderData = homeSliderData(context);
    final user = context.watch<UserCubit>().state;
    return Column(
      children: [
        Text(
          '${AppLocalizations.of(context)!.homeTop_welcome} ${user.userName}!',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          AppLocalizations.of(context)!.homeTop_donatingGood,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(
          height: 5,
        ),
        CarouselSlider.builder(
          itemCount: sliderData.length,
          itemBuilder: (context, index, realIndex) => Container(
            width: MediaQuery.of(context).size.width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              onTap: sliderData[index].onPressed,
              child: Image(
                fit: BoxFit.cover,
                image: sliderData[index].image.image,
                width: MediaQuery.of(context)
                    .size
                    .width, // Ensure the image takes the full width
              ),
            ),
          ),
          options: CarouselOptions(
            onPageChanged: (index, reason) => setState(() {
              currentIndex = index;
            }),
            viewportFraction: 1,
            aspectRatio: 2 / 1.5,
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 500),
            enlargeCenterPage:
                false, // Ensure the current image takes the full width without enlarging
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Center(
          // Wrap the SizedBox with a Center widget
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width *
                0.4, // Adjust the width as needed
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: MovingDot(isSelected: currentIndex == index),
              ),
              itemCount: sliderImages.length,
            ),
          ),
        ),
      ],
    );
  }
}
