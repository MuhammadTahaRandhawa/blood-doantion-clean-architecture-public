import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/core/features/app_user/presentation/bloc/user_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/features/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/cubit/bottom_navigation_bar_index_cubit.dart';
import 'package:myapp/core/features/comments/presentation/bloc/comments_bloc.dart';
import 'package:myapp/core/features/comments/presentation/cubit/comment_cubit.dart';
import 'package:myapp/core/features/location/presentation/bloc/location_bloc.dart';
import 'package:myapp/core/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:myapp/core/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:myapp/core/features/rating/presentation/bloc/ratings_bloc.dart';
import 'package:myapp/core/features/rating/presentation/cubit/rating_cubit.dart';
import 'package:myapp/core/features/report/presentation/bloc/report_bloc.dart';
import 'package:myapp/core/features/report/presentation/cubit/comment_cubit.dart';
import 'package:myapp/core/theme/theme.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/authenticated_loading/presentation/loading_screen.dart';
import 'package:myapp/features/blood_centers/presentation/bloc/blood_center_bloc.dart';
import 'package:myapp/features/blood_donations/presentation/bloc/blood_donation_bloc.dart';
import 'package:myapp/features/blood_map/presentation/bloc/blood_map_bloc.dart';
import 'package:myapp/features/blood_requests/presentation/bloc/blood_request_bloc.dart';
import 'package:myapp/features/blood_requests/presentation/cubit/blood_request_cubit.dart';
import 'package:myapp/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:myapp/features/chat/presentation/cubit/unread_messages_count_cubit.dart';
import 'package:myapp/features/chat/presentation/message_bloc/bloc/message_bloc.dart';
import 'package:myapp/features/settings/domain/entities/current_app_language.dart';
import 'package:myapp/features/settings/presentaion/cubit/current_app_language_cubit.dart';
import 'package:myapp/features/settings/presentaion/cubit/theme_mode_cubit.dart';
import 'package:myapp/features/splash/presentaion/pages/splash_page.dart';
import 'package:myapp/init_dependencies.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await initDependencies();
  await serviceLocator.allReady();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<NotificationBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<LocationBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<UserBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<BloodRequestBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<BloodRequestCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<MapsBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<BloodDonationBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<BloodMapBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<ChatBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<MessageBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<UnreadMessagesCountCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<UserCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<CommentsBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<CommentCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<RatingsBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<RatingCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<ReportBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<ReportCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<ThemeModeCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<AppointmentBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<AppointmentCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<BloodCenterBloc>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<CurrentAppLanguageCubit>(),
      ),
      BlocProvider(
        create: (context) => serviceLocator<BottomNavigationBarIndexCubit>(),
      ),
    ],
    child: const MyApp(),
  ));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final autheticatedUSer = serviceLocator<FirebaseAuth>().currentUser;
    final themeMode = context.watch<ThemeModeCubit>().state;
    CurrentAppLanguage currentAppLanguage =
        context.watch<CurrentAppLanguageCubit>().state;
    return MaterialApp(
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        locale: context
            .read<CurrentAppLanguageCubit>()
            .locale(currentAppLanguage.currentAppLanguageType),
        supportedLocales: const [
          Locale('en'),
          Locale('ur'),
        ],
        debugShowCheckedModeBanner: false,
        themeMode:
            context.read<ThemeModeCubit>().themeMode(themeMode.themeModeType),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: autheticatedUSer == null
            ? const SplashScreen()
            : const LoadingScreen());
  }
}
