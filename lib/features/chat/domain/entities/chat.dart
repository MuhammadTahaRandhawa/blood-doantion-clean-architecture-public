class Chat {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final String currentUserName;
  final String lastMessage;
  final String? currentUserImageUrl;
  final String? otherUserImageUrl;
  final DateTime lastMessageDateTime;
  final String lastMessageSentBy;
  final String? currentUserFcmToken;
  final String? otherUserFcmToken;

  Chat(
      {required this.chatId,
      required this.currentUserId,
      required this.otherUserId,
      required this.otherUserName,
      required this.currentUserName,
      required this.lastMessage,
      required this.currentUserImageUrl,
      required this.otherUserImageUrl,
      required this.lastMessageDateTime,
      required this.lastMessageSentBy,
      required this.currentUserFcmToken,
      required this.otherUserFcmToken});
}
