import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/features/notifications/domain/entities/notification_data.dart';
import 'package:myapp/features/chat/data/models/chat_model.dart';
import 'package:myapp/features/chat/data/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/features/chat/domain/entities/message.dart';

abstract interface class NotificationDataSource {
  Future<AuthorizationStatus> requestNotificationPermissions();
  Future<String> getFcmTokenOfDevice();
  Future<Unit> updateFcmTokeninFirestore(String fcmToken);
  Future<Unit> sendMessageNotificationFromOneDeviceToAnother(
      ChatModel chatModel, MessageModel messageModel);
  Future<Unit> sendScheduledNotification(
      NotificationData notificationData, DateTime dateTime);
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final FirebaseMessaging firebaseMessaging;

  NotificationDataSourceImpl(this.firebaseMessaging);
  @override
  Future<String> getFcmTokenOfDevice() async {
    try {
      final fcmToken = await firebaseMessaging.getToken();
      if (fcmToken == null) {
        throw ServerException('Fcm Token is Null');
      }
      if (kDebugMode) {
        print(fcmToken);
      }
      return fcmToken;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthorizationStatus> requestNotificationPermissions() async {
    try {
      final NotificationSettings settings =
          await firebaseMessaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('User Grants Permission');
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print('User Grants Provisional Permission');
        }
      } else {
        if (kDebugMode) {
          print('User Denied Permission');
        }
      }
      return settings.authorizationStatus;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateFcmTokeninFirestore(String fcmToken) {
    // TODO: implement updateFcmTokeninFirestore
    throw UnimplementedError();
  }

  @override
  Future<Unit> sendMessageNotificationFromOneDeviceToAnother(
      ChatModel chatModel, MessageModel messageModel) async {
    try {
      log('inside notifications data');
      // FCM Server Key
      String serverKey =
          'AAAAaFJxmek:APA91bHLjMjjx2mK_AHsdsRsVigrj8O8huEG5MB6QBxyTebMyZeSR58X9jQtUlq0Bd_3rM2bagmnhoHNBUGiLbN_i8JUfPDHBxfKWBK35RMWQm-nm3a3C11pV-4HV8mw1iW4Uk8kQjl7';

      // URL of FCM endpoint
      String url = 'https://fcm.googleapis.com/fcm/send';

      String notificationtTitle = chatModel.currentUserName;
      String? notificationBody = messageModel.text;

      if (messageModel.messageType == MessageType.donation &&
          messageModel.messageTypeId != null) {
        notificationtTitle = 'Great News';
        notificationBody =
            '${chatModel.currentUserName} Accepts your request. Go and start Chatting';
      }
      if (messageModel.messageType == MessageType.request &&
          messageModel.messageTypeId != null) {
        notificationtTitle = 'Emergency';
        notificationBody =
            '${chatModel.currentUserName}needs your help urgently.';
      }

      // Create the message body
      Map<String, dynamic> body = {
        'to': chatModel.otherUserFcmToken,
        'priority': 'high',
        'notification': {
          'title': notificationtTitle,
          'body': notificationBody,
        },
        'data': {
          'type': 'message',
          'senderName': chatModel.currentUserName,
          'senderId': chatModel.currentUserId,
          'senderfcmtoken': chatModel.currentUserFcmToken,
          'receiverId': chatModel.otherUserId
        }
      };

      print(body.toString());
      // Encode the body to JSON
      String encodedBody = json.encode(body);

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey', // Add FCM server key here
        },
        body: encodedBody,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        // Success response
        if (kDebugMode) {
          log('Request successful');
        }
        return unit;
      } else {
        // Throw an exception for non-successful status codes
        throw ServerException('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> sendScheduledNotification(
      NotificationData notificationData, DateTime dateTime) async {
    try {
      final currentTime = DateTime.now();
      final delay = dateTime.difference(currentTime).inMilliseconds;

      if (delay <= 0) {
        log('Immediately sent notification');
        _sendNotification(notificationData);
      } else {
        log('Notification scheduled in $delay milliseconds');

        // Schedule the notification
        Timer(Duration(milliseconds: delay),
            () => _sendNotification(notificationData));
      }

      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  _sendNotification(NotificationData notificationData) async {
    String serverKey =
        'AAAAaFJxmek:APA91bHLjMjjx2mK_AHsdsRsVigrj8O8huEG5MB6QBxyTebMyZeSR58X9jQtUlq0Bd_3rM2bagmnhoHNBUGiLbN_i8JUfPDHBxfKWBK35RMWQm-nm3a3C11pV-4HV8mw1iW4Uk8kQjl7';

    // URL of FCM endpoint
    String url = 'https://fcm.googleapis.com/fcm/send';
    Map<String, dynamic> body = {
      'to': notificationData.receiverFcmToken,
      'priority': 'high',
      'notification': {
        'title': notificationData.notificationTitle,
        'body': notificationData.notificationBody,
      },
      'data': {
        'type': NotificationData.notificationTypeToString(
            notificationData.notificationType),
        'senderName': notificationData.senderName,
        'senderId': notificationData.senderId,
        'senderfcmtoken': notificationData.senderFcmToken,
        'receiverId': notificationData.receiverId,
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      log('Notification sent successfully');
    } else {
      log('Failed to send notification: ${response.body}');
      throw ServerException('Failed to send notification: ${response.body}');
    }
  }
}
