import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myapp/core/features/app_user/data/datasource/user_local_data_source.dart';
import 'package:myapp/core/features/app_user/data/datasource/user_remote_data_source.dart';
import 'package:myapp/core/features/app_user/data/models/user_model.dart';
import 'package:myapp/core/features/app_user/data/models/user_model_adapter.dart';
import 'package:myapp/core/features/app_user/data/repositories/user_repository_impl.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/features/app_user/domain/usecases/fetch_other_user_data.dart';
import 'package:myapp/core/features/app_user/domain/usecases/fetch_user_data_remotly.dart';
import 'package:myapp/core/features/app_user/domain/usecases/post_blood_donation_doc_ref.dart';
import 'package:myapp/core/features/app_user/domain/usecases/submit_user_data_remotly.dart';
import 'package:myapp/core/features/app_user/domain/usecases/submit_user_profile_image.dart';
import 'package:myapp/core/features/app_user/domain/usecases/update_user_fcm_token.dart';
import 'package:myapp/core/features/app_user/domain/usecases/update_user_location_to_server.dart';
import 'package:myapp/core/features/app_user/presentation/bloc/user_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/data/datasources/appointment_remote_data_source.dart';
import 'package:myapp/core/features/appointments/data/repository/appointment_repository_impl.dart';
import 'package:myapp/core/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:myapp/core/features/appointments/domain/usecases/fetch_appointment_by_id.dart';
import 'package:myapp/core/features/appointments/domain/usecases/fetch_my_appointments.dart';
import 'package:myapp/core/features/appointments/domain/usecases/fetch_my_involved_appointments.dart';
import 'package:myapp/core/features/appointments/domain/usecases/fetch_stream_of_my_overall_appointments.dart';
import 'package:myapp/core/features/appointments/domain/usecases/submit_an_appointment.dart';
import 'package:myapp/core/features/appointments/domain/usecases/update_appointment_is_completed.dart';
import 'package:myapp/core/features/appointments/domain/usecases/update_appointment_status.dart';
import 'package:myapp/core/features/appointments/domain/usecases/update_appointment_status_and_time.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/features/appointments/presentation/cubit/appointment_cubit.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/cubit/bottom_navigation_bar_index_cubit.dart';
import 'package:myapp/core/features/comments/data/datasources/comments_remote_data_source.dart';
import 'package:myapp/core/features/comments/data/repositories/comment_repository_impl.dart';
import 'package:myapp/core/features/comments/domain/repository/comment_repository.dart';
import 'package:myapp/core/features/comments/domain/usecases/fetch_comments_on_donation.dart';
import 'package:myapp/core/features/comments/domain/usecases/fetch_comments_on_request.dart';
import 'package:myapp/core/features/comments/domain/usecases/post_a_comment_on_donation.dart';
import 'package:myapp/core/features/comments/domain/usecases/post_a_comment_on_request.dart';
import 'package:myapp/core/features/comments/presentation/bloc/comments_bloc.dart';
import 'package:myapp/core/features/comments/presentation/cubit/comment_cubit.dart';

import 'package:myapp/core/features/location/data/datasource/location_datasource.dart';
import 'package:myapp/core/features/location/data/repositories/location_repository_impl.dart';
import 'package:myapp/core/features/location/domain/repository/location_repository.dart';
import 'package:myapp/core/features/location/domain/usecases/get_current_address.dart';
import 'package:myapp/core/features/location/domain/usecases/get_current_location.dart';
import 'package:myapp/core/features/location/domain/usecases/get_current_position.dart';
import 'package:myapp/core/features/location/domain/usecases/get_location_permission.dart';
import 'package:myapp/core/features/location/presentation/bloc/location_bloc.dart';
import 'package:myapp/core/features/maps/data/datasources/maps_datasources.dart';
import 'package:myapp/core/features/maps/data/repositories/maps_repository_impl.dart';
import 'package:myapp/core/features/maps/domain/repository/maps_repository.dart';
import 'package:myapp/core/features/maps/domain/usecases/fetch_maps_static_image.dart';
import 'package:myapp/core/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:myapp/core/features/notifications/data/datasources/notification_data_source.dart';
import 'package:myapp/core/features/notifications/data/repository/notification_repository_impl.dart';
import 'package:myapp/core/features/notifications/domain/repository/notification_repository.dart';
import 'package:myapp/core/features/notifications/domain/usecases/get_fcm_token.dart';
import 'package:myapp/core/features/notifications/domain/usecases/request_notification_permission.dart';
import 'package:myapp/core/features/notifications/domain/usecases/send_message_notification_from_device_to_other.dart';
import 'package:myapp/core/features/notifications/domain/usecases/send_schedule_notification.dart';
import 'package:myapp/core/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:myapp/core/features/rating/data/datasources/ratings_remote_data_source.dart';
import 'package:myapp/core/features/rating/data/repositories/rating_repository_impl.dart';
import 'package:myapp/core/features/rating/domain/repository/rating_repository.dart';
import 'package:myapp/core/features/rating/domain/usecases/fetch_ratings_on_donation.dart';
import 'package:myapp/core/features/rating/domain/usecases/fetch_ratings_on_request.dart';
import 'package:myapp/core/features/rating/domain/usecases/post_a_rating_on_donation.dart';
import 'package:myapp/core/features/rating/domain/usecases/post_a_rating_on_request.dart';
import 'package:myapp/core/features/rating/presentation/bloc/ratings_bloc.dart';
import 'package:myapp/core/features/rating/presentation/cubit/rating_cubit.dart';
import 'package:myapp/core/features/report/data/datasources/reports_remote_data_source.dart';
import 'package:myapp/core/features/report/data/repositories/report_repository_impl.dart';
import 'package:myapp/core/features/report/domain/repository/report_repository.dart';
import 'package:myapp/core/features/report/domain/usecases/fetch_reports_on_donation.dart';
import 'package:myapp/core/features/report/domain/usecases/fetch_reports_on_request.dart';
import 'package:myapp/core/features/report/domain/usecases/post_a_report_on_donation.dart';
import 'package:myapp/core/features/report/domain/usecases/post_a_report_on_request.dart';
import 'package:myapp/core/features/report/presentation/bloc/report_bloc.dart';
import 'package:myapp/core/features/report/presentation/cubit/comment_cubit.dart';
import 'package:myapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:myapp/features/auth/domain/repository/auth_repository.dart';
import 'package:myapp/features/auth/domain/usercases/authenticate_with_google.dart';
import 'package:myapp/features/auth/domain/usercases/confirm_password_reset.dart';
import 'package:myapp/features/auth/domain/usercases/send_password_reset_email.dart';
import 'package:myapp/features/auth/domain/usercases/user_login.dart';
import 'package:myapp/features/auth/domain/usercases/user_sign_up.dart';
import 'package:myapp/features/auth/domain/usercases/verify_password_reset_code.dart';
import 'package:myapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:myapp/features/blood_centers/data/datasource/center_remote_datasource.dart';
import 'package:myapp/features/blood_centers/data/repository/blood_center_repository_impl.dart';
import 'package:myapp/features/blood_centers/domain/repository/blood_center_repository.dart';
import 'package:myapp/features/blood_centers/domain/usecases/fetch_blood_centers_around_user.dart';
import 'package:myapp/features/blood_centers/domain/usecases/fetch_center_by_id.dart';
import 'package:myapp/features/blood_centers/presentation/bloc/blood_center_bloc.dart';
import 'package:myapp/features/blood_donations/data/datasources/blood_donation_datasources.dart';
import 'package:myapp/features/blood_donations/data/repositories/blood_donation_repository_impl.dart';
import 'package:myapp/features/blood_donations/domain/repository/blood_donation_repository.dart';
import 'package:myapp/features/blood_donations/domain/usecases/fetch_donation_by_id.dart';
import 'package:myapp/features/blood_donations/domain/usecases/fetch_donation_inside_certain_radius.dart';
import 'package:myapp/features/blood_donations/domain/usecases/fetch_donations.dart';
import 'package:myapp/features/blood_donations/domain/usecases/fetch_my_donations.dart';
import 'package:myapp/features/blood_donations/domain/usecases/post_a_donation.dart';
import 'package:myapp/features/blood_donations/domain/usecases/streamof_donations_in_certain_radius.dart';
import 'package:myapp/features/blood_donations/domain/usecases/turn_off_donation.dart';
import 'package:myapp/features/blood_donations/presentation/bloc/blood_donation_bloc.dart';
import 'package:myapp/features/blood_map/data/datasources/blood_map_remote_data_source.dart';
import 'package:myapp/features/blood_map/data/repositories/blood_map_repository_impl.dart';
import 'package:myapp/features/blood_map/domain/repositories/bloodmap_repository.dart';
import 'package:myapp/features/blood_map/domain/usecases/fetch_centers_map_markers_around_user.dart';
import 'package:myapp/features/blood_map/domain/usecases/fetch_donations_map_markers_around_user.dart';
import 'package:myapp/features/blood_map/domain/usecases/fetch_requests_maps_markers_around_user.dart';
import 'package:myapp/features/blood_map/presentation/bloc/blood_map_bloc.dart';
import 'package:myapp/features/blood_requests/data/datamodels/request_model.dart';
import 'package:myapp/features/blood_requests/data/datamodels/request_model_adapter.dart';
import 'package:myapp/features/blood_requests/data/datasources/blood_request_remote_data_source.dart';
import 'package:myapp/features/blood_requests/data/datasources/blood_requests_local_data_source.dart';
import 'package:myapp/features/blood_requests/data/repositories/blood_request_repository_impl.dart';
import 'package:myapp/features/blood_requests/domain/repository/blood_request_repository.dart';
import 'package:myapp/features/blood_requests/domain/usecases/fetchRequests.dart';
import 'package:myapp/features/blood_requests/domain/usecases/fetch_my_requests.dart';
import 'package:myapp/features/blood_requests/domain/usecases/fetch_request_by_id.dart';
import 'package:myapp/features/blood_requests/domain/usecases/fetch_requests_in_certain_radius.dart';
import 'package:myapp/features/blood_requests/domain/usecases/post_a_new_request.dart';
import 'package:myapp/features/blood_requests/domain/usecases/streamof_requests_in_certain_radius.dart';
import 'package:myapp/features/blood_requests/presentation/bloc/blood_request_bloc.dart';
import 'package:myapp/features/blood_requests/presentation/cubit/blood_request_cubit.dart';
import 'package:myapp/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:myapp/features/chat/data/datasources/messages_remote_data_source.dart';
import 'package:myapp/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:myapp/features/chat/data/repositories/message_repository_impl.dart';
import 'package:myapp/features/chat/domain/repositories/chat_repository.dart';
import 'package:myapp/features/chat/domain/repositories/message_repository.dart';
import 'package:myapp/features/chat/domain/usecases/fetch_chats_of_user.dart';
import 'package:myapp/features/chat/domain/usecases/fetch_messages_from_chat.dart';
import 'package:myapp/features/chat/domain/usecases/fetch_unread_messages_count.dart';
import 'package:myapp/features/chat/domain/usecases/mark_messages_as_viewed.dart';
import 'package:myapp/features/chat/domain/usecases/send_a_message.dart';
import 'package:myapp/features/chat/domain/usecases/send_approved_message.dart';
import 'package:myapp/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:myapp/features/chat/presentation/cubit/unread_messages_count_cubit.dart';
import 'package:myapp/features/chat/presentation/message_bloc/bloc/message_bloc.dart';
import 'package:myapp/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:myapp/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repositories.dart';
import 'package:myapp/features/settings/domain/usecases/get_current_app_language.dart';
import 'package:myapp/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:myapp/features/settings/domain/usecases/set_current_app_language.dart';
import 'package:myapp/features/settings/domain/usecases/set_theme_mode.dart';
import 'package:myapp/features/settings/presentaion/cubit/current_app_language_cubit.dart';
import 'package:myapp/features/settings/presentaion/cubit/theme_mode_cubit.dart';
import 'package:myapp/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  serviceLocator
    ..registerSingleton<FirebaseAuth>(FirebaseAuth.instance)
    ..registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance)
    ..registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance)
    ..registerSingleton<FirebaseStorage>(FirebaseStorage.instance)
    ..registerFactory<InternetConnection>(
        () => InternetConnection.createInstance())
    ..registerSingleton<SharedPreferences>(
        await SharedPreferences.getInstance());

  _initAuth();

  _initNotifications();
  _initLocation();
  _initUser();
  _initRequests();
  _initDonations();
  _initBloodMap();
  _initMaps();
  _initChat();
  _initComments();
  _initRatings();
  _initReports();
  _initSetting();
  _initAppointments();
  _initCenters();
  _initBottomNavigation();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceimpl(serviceLocator()))
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator()))
    ..registerSingleton<UserLogIn>(UserLogIn(serviceLocator()))
    ..registerSingleton<UserSignUp>(UserSignUp(serviceLocator()))
    ..registerSingleton<AuthenticateWithGoogle>(
        AuthenticateWithGoogle(serviceLocator()))
    ..registerSingleton<ConfirmPasswordReset>(
        ConfirmPasswordReset(serviceLocator()))
    ..registerSingleton<SendPasswordResetEmail>(
        SendPasswordResetEmail(serviceLocator()))
    ..registerSingleton<VerifyPasswordResetCode>(
        VerifyPasswordResetCode(serviceLocator()))
    ..registerSingleton(AuthBloc(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ));
}

void _initNotifications() {
  serviceLocator.registerSingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin());

  serviceLocator.registerFactory<NotificationDataSource>(
      () => NotificationDataSourceImpl(serviceLocator()));

  serviceLocator.registerFactory<NotificationRepository>(
      () => NotificationRepositoryImpl(serviceLocator()));

  serviceLocator.registerSingleton<GetFcmToken>(GetFcmToken(serviceLocator()));

  serviceLocator.registerSingleton<RequestNotificationPermission>(
      RequestNotificationPermission(serviceLocator()));
  serviceLocator.registerSingleton<SendMessageNotificationFromDeviceToAnother>(
      SendMessageNotificationFromDeviceToAnother(serviceLocator()));

  serviceLocator.registerSingleton<SendScheduleNotification>(
      SendScheduleNotification(serviceLocator()));

  serviceLocator.registerSingleton<NotificationBloc>(NotificationBloc(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator()));
}

void _initLocation() {
  serviceLocator
      .registerFactory<LocationDataSource>(() => LocationDataSourceImpl());
  serviceLocator.registerFactory<LocationRepository>(
      () => LocationRepositoryImpl(serviceLocator()));

  serviceLocator.registerSingleton<GetCurrentAddress>(
      GetCurrentAddress(serviceLocator()));
  serviceLocator.registerSingleton<GetCurrentLocation>(
      GetCurrentLocation(serviceLocator()));

  serviceLocator.registerSingleton<GetCurrentPosition>(
      GetCurrentPosition(serviceLocator()));

  serviceLocator.registerSingleton<GetLocationPermission>(
      GetLocationPermission(serviceLocator()));

  serviceLocator.registerSingleton<LocationBloc>(LocationBloc(
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
}

void _initUser() async {
  Hive.registerAdapter(UserModelAdapter());
  serviceLocator.registerSingletonAsync<Box<UserModel>>(
      () async => await Hive.openBox<UserModel>('user'));
  await serviceLocator.allReady();

  serviceLocator
    ..registerFactory<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(
        serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerFactory<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(serviceLocator.get<Box<UserModel>>()))
    ..registerFactory<UserRepository>(() => UserRepositoryImpl(
        serviceLocator(), serviceLocator(), serviceLocator()));

  serviceLocator.registerFactory(() => SubmitUserDataRemotly(serviceLocator()));
  serviceLocator.registerFactory(() => FetchUserDataRemotly(serviceLocator()));
  serviceLocator
      .registerFactory(() => SubmitUserProfileImage(serviceLocator()));
  serviceLocator
      .registerFactory(() => UpdateUserLocationToServer(serviceLocator()));
  serviceLocator
    ..registerFactory(() => PostBloodDonationDocRef(serviceLocator()))
    ..registerFactory(() => UpdateUserFcmToken(serviceLocator()))
    ..registerFactory(() => FetchOtherUserData(serviceLocator()));

  serviceLocator.registerSingleton(UserBloc(
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
  ));
  serviceLocator.registerSingleton(UserCubit());
}

void _initRequests() async {
  Hive.registerAdapter(RequestModelAdapter());

  serviceLocator
    ..registerSingletonAsync<Box<RequestModel>>(
        () async => await Hive.openBox<RequestModel>('bloodRequests'))
    ..registerFactory<BloodRequestsRemoteDataSource>(() =>
        BloodRequestsRemoteDataSourceImpl(serviceLocator(), serviceLocator()));
  await serviceLocator.allReady();
  serviceLocator
    ..registerFactory<BloodRequestsLocalDataSource>(
        () => BloodRequestsLocalDataSourceImpl(
              serviceLocator.get<Box<RequestModel>>(),
            ))
    ..registerFactory<BloodRequestRepository>(() => BloodRequestRepositoryImpl(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ))
    ..registerFactory(() => FetchRequests(serviceLocator()))
    ..registerFactory(() => PostANewBloodRequest(serviceLocator()))
    ..registerFactory(() => StreamOfRequestsInCertainRadius(serviceLocator()))
    ..registerFactory(() => FetchMyRequests(serviceLocator()))
    ..registerFactory(() => FetchRequestById(serviceLocator()))
    ..registerFactory(() => FetchBloodRequestsInCertainRadius(serviceLocator()))
    ..registerSingleton(BloodRequestCubit())
    ..registerSingleton(BloodRequestBloc(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ));
}

void _initDonations() {
  serviceLocator.registerFactory<BloodDonationDataSources>(
      () => BloodDonationDataSourcesImpl(serviceLocator(), serviceLocator()));

  serviceLocator.registerFactory<BloodDonationRespository>(
      () => BloodDonationRepositoryImpl(serviceLocator()));

  serviceLocator.registerFactory(() => FetchDonations(serviceLocator()));
  serviceLocator.registerFactory(
      () => StreamOfDonationsInCertainRadius(serviceLocator()));
  serviceLocator.registerFactory(() => PostADonation(serviceLocator()));

  serviceLocator.registerFactory(
      () => FetchDonationsInsideCertainRadius(serviceLocator()));
  serviceLocator.registerFactory(() => FetchDonationById(serviceLocator()));

  serviceLocator.registerFactory(() => FetchMyDonation(serviceLocator()));
  serviceLocator.registerFactory(() => TurnOffDonation(serviceLocator()));

  serviceLocator.registerSingleton(BloodDonationBloc(
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
  ));
}

void _initBloodMap() {
  serviceLocator
    ..registerFactory<BloodMapRemoteDataSource>(
        () => BloodMapRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<BloodMapRepository>(
        () => BloodMapRepositoryImpl(serviceLocator()))
    ..registerFactory(
        () => FetchDonationsMapsMarkersAroundUser(serviceLocator()))
    ..registerFactory(
        () => FetchRequestsMapsMarkersAroundUser(serviceLocator()))
    ..registerFactory(() => FetchCentersMapsMarkersAroundUser(serviceLocator()))
    ..registerSingleton<BloodMapBloc>(BloodMapBloc(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ));
}

void _initComments() {
  serviceLocator
    ..registerFactory<CommentsRemoteDataSource>(
        () => CommentsRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<CommentRepository>(
        () => CommentRepositoryImpl(serviceLocator()))
    ..registerFactory(() => FetchCommentsOnRequest(serviceLocator()))
    ..registerFactory(() => FetchCommentsOnDonation(serviceLocator()))
    ..registerFactory(() => PostACommentOnDonation(serviceLocator()))
    ..registerFactory(() => PostACommentOnRequest(serviceLocator()))
    ..registerSingleton<CommentsBloc>(CommentsBloc(
        serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerSingleton<CommentCubit>(CommentCubit());
}

void _initRatings() {
  serviceLocator
    ..registerFactory<RatingsRemoteDataSource>(
        () => RatingsRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<RatingRepository>(
        () => RatingRepositoryImpl(serviceLocator()))
    ..registerFactory(() => FetchRatingsOnRequest(serviceLocator()))
    ..registerFactory(() => FetchRatingsOnDonation(serviceLocator()))
    ..registerFactory(() => PostARatingOnDonation(serviceLocator()))
    ..registerFactory(() => PostARatingOnRequest(serviceLocator()))
    ..registerSingleton<RatingsBloc>(RatingsBloc(
        serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerSingleton<RatingCubit>(RatingCubit());
}

void _initReports() {
  serviceLocator
    ..registerFactory<ReportsRemoteDataSource>(
        () => ReportsRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<ReportRepository>(
        () => ReportRepositoryImpl(serviceLocator()))
    ..registerFactory(() => FetchReportsOnDonation(serviceLocator()))
    ..registerFactory(() => FetchReportsOnRequest(serviceLocator()))
    ..registerFactory(() => PostAReportOnDonation(serviceLocator()))
    ..registerFactory(() => PostAReportOnRequest(serviceLocator()))
    ..registerSingleton<ReportBloc>(ReportBloc(
        serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()))
    ..registerSingleton<ReportCubit>(ReportCubit());
}

void _initChat() {
  serviceLocator.registerFactory<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory<MessagesRemoteDataSource>(
      () => MessageRemoteDataSourceImpl(serviceLocator(), serviceLocator()));

  serviceLocator.registerFactory<ChatRepository>(
      () => ChatRepositoryImpl(serviceLocator()));
  serviceLocator.registerFactory<MessageRepository>(
      () => MessageRepositoryImpl(serviceLocator()));

  serviceLocator.registerFactory(() => FetchChatsOfuser(serviceLocator()));
  serviceLocator.registerFactory(() => FetchMessagesFromChat(serviceLocator()));
  serviceLocator.registerFactory(() => SendAMessage(serviceLocator()));
  serviceLocator
      .registerFactory(() => FetchUnreadMessagesCount(serviceLocator()));
  serviceLocator.registerFactory(() => MarkMessagesAsViewed(serviceLocator()));
  serviceLocator.registerFactory(() => SendApprovedRequest(serviceLocator()));

  serviceLocator.registerSingleton(ChatBloc(
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
    serviceLocator(),
  ));
  serviceLocator
      .registerSingleton(MessageBloc(serviceLocator(), serviceLocator()));
  serviceLocator.registerSingleton(UnreadMessagesCountCubit(serviceLocator()));
}

void _initMaps() {
  serviceLocator.registerFactory<MapsDataSource>(() => MapsDataSourceImpl());
  serviceLocator.registerFactory<MapsRepository>(
      () => MapsRepositoryImpl(serviceLocator()));
  serviceLocator.registerFactory<FetchMapsStaticImage>(
      () => FetchMapsStaticImage(serviceLocator()));
  serviceLocator.registerSingleton<MapsBloc>(MapsBloc(serviceLocator()));
}

void _initSetting() async {
  await serviceLocator.allReady();
  serviceLocator
    ..registerFactory<SettingsLocalDataSource>(
        () => SettingsLocalDataSourceImpl(serviceLocator()))
    ..registerFactory<SettingsRepository>(
        () => SettingsRepositoryImpl(serviceLocator()))
    ..registerFactory(() => GetThemeMode(serviceLocator()))
    ..registerFactory(() => SetThemeMode(serviceLocator()))
    ..registerFactory(() => GetCurrentAppLanguage(serviceLocator()))
    ..registerFactory(() => SetCurrentAppLanguage(serviceLocator()))
    ..registerSingleton<ThemeModeCubit>(ThemeModeCubit(
      serviceLocator(),
      serviceLocator(),
    ))
    ..registerSingleton<CurrentAppLanguageCubit>(CurrentAppLanguageCubit(
      serviceLocator(),
      serviceLocator(),
    ));
}

void _initAppointments() {
  serviceLocator
    ..registerFactory<AppointmentRemoteDataSource>(
        () => AppointRemoteDataSourceImpl(serviceLocator(), serviceLocator()))
    ..registerFactory<AppointmentRepository>(
        () => AppointmentRepositoryImpl(serviceLocator()))
    ..registerFactory(() => FetchMyAppointments(serviceLocator()))
    ..registerFactory(() => FetchMyInvlovedAppointments(serviceLocator()))
    ..registerFactory(() => SubmitAnAppointment(serviceLocator()))
    ..registerFactory(() => UpdateAppointmentStatusAndTime(serviceLocator()))
    ..registerFactory(() => UpdateIsAppointmentCompleted(serviceLocator()))
    ..registerFactory(() => FetchAppointmentsById(serviceLocator()))
    ..registerFactory(
        () => FetchStreamOfMyOverallAppointments(serviceLocator()))
    ..registerFactory(() => UpdateAppointmentStatus(serviceLocator()))
    ..registerSingleton<AppointmentCubit>(AppointmentCubit())
    ..registerSingleton<AppointmentBloc>(AppointmentBloc(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ));
}

void _initCenters() {
  serviceLocator
    ..registerFactory<CenterRemoteDataSource>(
        () => CenterRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<BloodCenterRepository>(
        () => BloodCenterRepositoryImpl(serviceLocator()))
    ..registerFactory(() => FetchBloodCentersAroundUser(serviceLocator()))
    ..registerFactory(() => FetchCenterById(serviceLocator()))
    ..registerSingleton<BloodCenterBloc>(BloodCenterBloc(
      serviceLocator(),
      serviceLocator(),
    ));
}

void _initBottomNavigation() {
  serviceLocator.registerSingleton(BottomNavigationBarIndexCubit());
}
