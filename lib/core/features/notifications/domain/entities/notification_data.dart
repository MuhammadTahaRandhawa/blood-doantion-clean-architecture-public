class NotificationData {
  final String notificationTitle;
  final String notificationBody;
  final String senderName;
  final String senderId;
  final String senderFcmToken;
  final String receiverId;
  final String receiverFcmToken;
  final NotificationType notificationType;

  NotificationData({
    required this.notificationTitle,
    required this.notificationBody,
    required this.senderName,
    required this.senderId,
    required this.senderFcmToken,
    required this.receiverId,
    required this.receiverFcmToken,
    required this.notificationType,
  });

  static String notificationTypeToString(NotificationType notificationType) {
    switch (notificationType) {
      case NotificationType.appointment:
        return 'appointment';
      case NotificationType.donation:
        return 'donation';
      case NotificationType.message:
        return 'message';
      case NotificationType.request:
        return 'request';
      default:
        throw ArgumentError();
    }
  }
}

enum NotificationType { message, appointment, donation, request }
