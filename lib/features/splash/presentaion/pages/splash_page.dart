import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/features/auth/presentation/pages/login_page.dart';
import 'package:myapp/features/auth/presentation/pages/sign_up_page.dart';
import 'package:myapp/features/splash/presentaion/widgets/slider_with_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final CarouselController carouselController = CarouselController();
  int controller = 0;

  @override
  void dispose() {
    super.dispose();
  }

  onPageChanged(int value) {
    setState(() {
      controller = value;
      // carouselController.jumpToPage(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              const SizedBox(
                height: 20,
              ),
              const SliderWithText(),
              const Spacer(),
              LargeGradientButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.splash_largeButton,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
                  },
                  child: RichText(
                      text: TextSpan(
                          text: AppLocalizations.of(context)!
                              .splash_loginButtonText1,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                          children: [
                        TextSpan(
                            text:
                                ' ${AppLocalizations.of(context)!.splash_loginButtonText2} ',
                            style: const TextStyle().copyWith(
                                color: AppPallete.primaryColor,
                                fontWeight: FontWeight.bold))
                      ]))),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
