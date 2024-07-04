
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel(
      {required super.chatId,
      required super.currentUserId,
      required super.otherUserId,
      required super.otherUserName,
      required super.currentUserName,
      required super.lastMessage,
      required super.currentUserImageUrl,
      required super.otherUserImageUrl,
      required super.lastMessageDateTime,
      required super.lastMessageSentBy,
      required super.currentUserFcmToken,
      required super.otherUserFcmToken});

  factory ChatModel.fromJson(
      Map<String, dynamic> map, FirebaseAuth firebaseAuth) {
    final String currentId = firebaseAuth.currentUser!.uid;

    String otherUserId = '';
    final participants = map['participants'];
    for (var element in participants) {
      if (element != currentId) {
        otherUserId = element;
      }
    }
    final model = ChatModel(
        chatId: map['chatId'],
        lastMessage: map['lastMessage'],
        lastMessageDateTime: map['lastMessageDateTime'].toDate(),
        lastMessageSentBy: map['lastMessageSentBy'],
        currentUserId: firebaseAuth.currentUser!.uid,
        otherUserId: otherUserId,
        otherUserName: map[otherUserId],
        currentUserName: map[currentId],
        currentUserImageUrl: map['imgurl$currentId'],
        otherUserImageUrl: map['imgurl$otherUserId'],
        currentUserFcmToken: map['fcmToken$currentId'],
        otherUserFcmToken: map['fcmToken$otherUserId']);

    return model;
  }

  factory ChatModel.fromChat(Chat chat) {
    return ChatModel(
        chatId: chat.chatId,
        currentUserId: chat.currentUserId,
        otherUserId: chat.otherUserId,
        otherUserName: chat.otherUserName,
        currentUserName: chat.currentUserName,
        lastMessage: chat.lastMessage,
        currentUserImageUrl: chat.currentUserImageUrl,
        otherUserImageUrl: chat.otherUserImageUrl,
        lastMessageDateTime: chat.lastMessageDateTime,
        lastMessageSentBy: chat.lastMessageSentBy,
        currentUserFcmToken: chat.currentUserFcmToken,
        otherUserFcmToken: chat.otherUserFcmToken);
  }
}
