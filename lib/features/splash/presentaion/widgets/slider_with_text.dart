import 'package:flutter/material.dart';
import 'package:myapp/core/widgets/custom_animated_container.dart';
import 'package:myapp/core/widgets/moving_dot.dart';
import 'package:myapp/features/splash/presentaion/consts/slider_images.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SliderWithText extends StatefulWidget {
  const SliderWithText({super.key});

  @override
  State<SliderWithText> createState() => _SliderWithTextState();
}

class _SliderWithTextState extends State<SliderWithText> {
  int controller = 0;

  @override
  void initState() {
    super.initState();
  }

  void onPageChanged(int value) {
    setState(() {
      controller = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> sliderText = getData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomAnimatedContainer(
            images: sliderImages, onPageChanged: onPageChanged),
        const SizedBox(
          height: 20,
        ),
        Text(
          sliderText[controller].entries.first.key,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          sliderText[controller].entries.first.value,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
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
                child:
                    MovingDot(isSelected: index == controller ? true : false),
              ),
              itemCount: sliderImages.length,
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, String>> getData() {
    List<Map<String, String>> sliderText = [
      {
        AppLocalizations.of(context)!.splash_slider1title:
            AppLocalizations.of(context)!.splash_slider1content
      },
      {
        AppLocalizations.of(context)!.splash_slider2title:
            AppLocalizations.of(context)!.splash_slider2content
      },
      {
        AppLocalizations.of(context)!.splash_slider3title:
            AppLocalizations.of(context)!.splash_slider3content
      },
      {
        AppLocalizations.of(context)!.splash_slider4title:
            AppLocalizations.of(context)!.splash_slider4content
      },
      {
        AppLocalizations.of(context)!.splash_slider5title:
            AppLocalizations.of(context)!.splash_slider5content
      },
      {
        AppLocalizations.of(context)!.splash_slider6title:
            AppLocalizations.of(context)!.splash_slider6content
      },
      {
        AppLocalizations.of(context)!.splash_slider7title:
            AppLocalizations.of(context)!.splash_slider7content
      }
    ];

    return sliderText;
  }
}
