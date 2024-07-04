import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    show
        FlutterLocalNotificationsPlugin,
        AndroidNotificationDetails,
        Importance,
        Priority,
        DarwinNotificationDetails,
        NotificationDetails,
        InitializationSettings,
        AndroidInitializationSettings,
        DarwinInitializationSettings;
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/notifications/domain/entities/notification_data.dart';
import 'package:myapp/core/features/notifications/domain/usecases/get_fcm_token.dart';
import 'package:myapp/core/features/notifications/domain/usecases/request_notification_permission.dart';
import 'package:myapp/core/features/notifications/domain/usecases/send_message_notification_from_device_to_other.dart';
import 'package:myapp/core/features/notifications/domain/usecases/send_schedule_notification.dart';
import 'package:myapp/core/utilis/get_conversation_id.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/presentation/pages/chats_page.dart';
import 'package:myapp/features/chat/presentation/pages/messages_page.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  /* Add this line to Androidmanifest.xml 
 <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="high_importance_channel" />*/
  final RequestNotificationPermission requestNotificationPermission;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GetFcmToken getFcmToken;
  final SendMessageNotificationFromDeviceToAnother
      sendMessageNotificationFromDeviceToAnother;
  final SendScheduleNotification sendScheduleNotification;
  NotificationBloc(
      this.requestNotificationPermission,
      this.flutterLocalNotificationsPlugin,
      this.getFcmToken,
      this.sendMessageNotificationFromDeviceToAnother,
      this.sendScheduleNotification)
      : super(NotificationInitial()) {
    on<NotificationsPermissionRequested>(notificationsPermissionRequested);
    on<NotificationDeviceFcmTokenRequested>(
        notificationDeviceFcmTokenRequested);
    on<FirebaseMessagingInitialized>(firebaseMessagingInitialized);
    on<LocalNotificationDisplayed>(localNotificationDisplayed);
    on<LocalNotificationsInitialized>(localNotificationsInitialized);
    on<NotificationMessageHandled>(notificationMessageHandled);
    on<SetupInteractedMessage>(setupInteractedMessage);
    on<NotificationFromOneDeviceToAnotherSent>(
        notificationFromOneDeviceToAnotherSent);
    on<ScheduledNotificationSent>(scheduledNotificationSent);
  }

  notificationsPermissionRequested(
      NotificationsPermissionRequested event, Emitter emit) async {
    emit(NotificationPermissionLoading());
    final response = await requestNotificationPermission.call(unit);
    response.fold((l) => emit(NotificationPermissionFailure(l.message)), (r) {
      if (r == AuthorizationStatus.authorized ||
          r == AuthorizationStatus.authorized) {
        emit(NotificationPermissionSuccess());
      } else {
        emit(NotificationPermissionFailure(
            'Notification Permissions were Not Given'));
      }
    });
  }

  notificationDeviceFcmTokenRequested(
      NotificationDeviceFcmTokenRequested event, Emitter emit) async {
    emit(GetFcmTokenLoading());
    final response = await getFcmToken.call(unit);
    response.fold((l) => emit(GetFcmTokenFailure(l.message)),
        (r) => emit(GetFcmTokenSuccess(r)));
  }

  firebaseMessagingInitialized(
      FirebaseMessagingInitialized event, Emitter emit) {
    final user = event.user;
    final context = event.context;
    log('insiden firebaseMessagingInitialized');
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title);
      }
      log('firebaseMessagingInitialized listened');
      context
          .read<NotificationBloc>()
          .add(LocalNotificationsInitialized(message, context));
      if (message.data['receiverId'] == user.userId) {
        context
            .read<NotificationBloc>()
            .add(LocalNotificationDisplayed(message));
      }
    });
  }

  localNotificationDisplayed(
      LocalNotificationDisplayed event, Emitter emit) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel id', 'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher');
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      event.remoteMessage.notification.hashCode,
      event.remoteMessage.notification!.title,
      event.remoteMessage.notification!.body,
      platformChannelSpecifics,
    );
  }

  localNotificationsInitialized(
      LocalNotificationsInitialized event, Emitter emit) async {
    final context = event.context;
    final message = event.remoteMessage;

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        context
            .read<NotificationBloc>()
            .add(NotificationMessageHandled(message, context));
      },
    );
  }

  notificationMessageHandled(
      NotificationMessageHandled event, Emitter emitter) {
    final message = event.remoteMessage;
    final context = event.context;
    final currentUser = context.watch<UserCubit>().state;
    if (message.data.containsKey('type')) {
      if (message.data['type'] == 'chat') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ChatPage(),
        ));
      } else if (message.data['type'] == 'message' &&
          message.data['receiverId'] == currentUser.userId) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessagesPage(
              chat: Chat(
                  chatId: getconversationIdHash(
                      currentUser.userId, message.data['senderId']),
                  currentUserId: currentUser.userId,
                  otherUserId: message.data['senderId'],
                  otherUserName: message.data['senderName'],
                  currentUserName: currentUser.userName,
                  lastMessage: '',
                  currentUserImageUrl: currentUser.userName,
                  otherUserImageUrl: null,
                  lastMessageDateTime: DateTime.now(),
                  lastMessageSentBy: currentUser.userId,
                  currentUserFcmToken: currentUser.fcmToken,
                  otherUserFcmToken: message.data['senderfcmtoken'])),
        ));
      }
    }
  }

  setupInteractedMessage(SetupInteractedMessage event, Emitter emit) async {
    final context = event.context;
    // Get any messages which caused the application to open from a terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // ignore: use_build_context_synchronously
      context
          .read<NotificationBloc>()
          .add(NotificationMessageHandled(initialMessage, context));
    }

    // Also handle any interaction when the app is in the background via a Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        context
            .read<NotificationBloc>()
            .add(NotificationMessageHandled(message, context));
      },
    );
  }

  notificationFromOneDeviceToAnotherSent(
      NotificationFromOneDeviceToAnotherSent event, Emitter emit) async {
    await sendMessageNotificationFromDeviceToAnother
        .call(MessageNotificationParams(event.chat, event.message));
  }

  @override
  void onTransition(
      Transition<NotificationEvent, NotificationState> transition) {
    if (kDebugMode) {
      print(transition);
    }
    super.onTransition(transition);
  }

  scheduledNotificationSent(
      ScheduledNotificationSent event, Emitter emit) async {
    final res = await sendScheduleNotification.call(
        ScheduledNotificationParams(event.notificationData, event.dateTime));
    res.fold((l) => emit(ScheduledNotificationSentFailure(l.message)),
        (r) => emit(ScheduledNotificationSentSuccess()));
  }
}
