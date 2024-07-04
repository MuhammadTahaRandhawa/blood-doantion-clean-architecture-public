import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ChatHelpers {
  ChatHelpers._();

  static String convertChatDateTimeToString(DateTime dateTime) {
    final DateTime now = DateTime.now();

    // Check if the given DateTime is today
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    if (isToday) {
      // Format time in 12-hour format
      final DateFormat timeFormatter = DateFormat('hh:mm a');
      return timeFormatter.format(dateTime);
    } else {
      // Format date in dd/MM/yyyy format
      final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
      return dateFormatter.format(dateTime);
    }
  }

// Play the notification sound
  static Future<void> playSendSound() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    final result = await audioPlayer.play(AssetSource(kIsWeb
        ? 'sounds/mixkit-message-pop-alert-2354.mp3'
        : 'assets/sounds/mixkit-message-pop-alert-2354.mp3'));
  }

  static Future<void> playreceivedSound() async {
    final AudioPlayer audioPlayer = AudioPlayer();
    final result = await audioPlayer.play(AssetSource(kIsWeb
        ? 'sounds/mixkit-dry-pop-up-notification-alert-2356.wav'
        : 'assets/sounds/mixkit-dry-pop-up-notification-alert-2356.wav'));
  }

  // static String convertMessageDateTimeToString(DateTime dateTime) {
  //   final amPm = dateTime.hour > 11 ? 'Pm' : 'Am';
  //   return '${dateTime.hour}:${dateTime.minute} $amPm';
  // }
}
