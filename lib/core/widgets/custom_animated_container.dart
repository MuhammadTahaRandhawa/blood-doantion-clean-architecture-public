import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomAnimatedContainer extends StatelessWidget {
  const CustomAnimatedContainer(
      {super.key, required this.onPageChanged, required this.images});
  final Function(int) onPageChanged;
  final List<AssetImage> images;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: images.length,
        itemBuilder: (context, index, realIndex) => Container(
              width: MediaQuery.of(context).size.width,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image(
                fit: BoxFit.cover,
                image: images[index],
              ),
            ),
        options: CarouselOptions(
          onPageChanged: (index, reason) => onPageChanged(index),
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          enlargeCenterPage: true,
        ));
  }
}
