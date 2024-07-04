import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/bloc/user_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/pages/bottom_navigation_bar.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/init_dependencies.dart';
import 'package:myapp/main.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
    context.read<UserBloc>().add(UserDataFetchedRemotly());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserFetchedSuccess) {
          context.read<UserCubit>().initializeUser(state.user);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AppBottomNavigation(),
          ));
        }
        if (state is UserFetchedFailure) {
          serviceLocator<FirebaseAuth>().signOut();

          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MyApp(),
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppPallete.gradientColor,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'I Donate Life ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          Image.asset(
                            kIsWeb
                                ? 'images/hand_with_heart.png'
                                : 'assets/images/hand_with_heart.png',
                            width: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize! +
                                10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
