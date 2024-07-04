import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/features/chat/data/models/chat_model.dart';
import 'package:myapp/features/chat/data/models/message_model.dart';

abstract interface class MessagesRemoteDataSource {
  Future<Unit> sendAMessage(ChatModel chatModel, MessageModel messageModel);
  Stream<List<MessageModel>> fetchMessagesFromChat(String chatId);
  Stream<Map<String, int>> getUnreadMessagesCount();
  Future<Unit> markMessagesAsViewed(ChatModel chatModel);
  Future<Unit> sendApprovedMessage(
      ChatModel chatModel, MessageModel messageModel);
}

class MessageRemoteDataSourceImpl implements MessagesRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  MessageRemoteDataSourceImpl(this.firebaseFirestore, this.firebaseAuth);
  @override
  Stream<List<MessageModel>> fetchMessagesFromChat(String chatId) {
    try {
      return FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timeSent', descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => MessageModel.fromJson(e.data())).toList());
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> sendAMessage(
      ChatModel chatModel, MessageModel messageModel) async {
    try {
      var batch = FirebaseFirestore.instance.batch();

      var conversationDocRef =
          FirebaseFirestore.instance.collection('chats').doc(chatModel.chatId);

      batch.set(conversationDocRef, {
        'chatId': chatModel.chatId,
        'participants': [chatModel.currentUserId, chatModel.otherUserId],
        chatModel.currentUserId: chatModel.currentUserName,
        chatModel.otherUserId: chatModel.otherUserName,
        'lastMessage': messageModel.text,
        'lastMessageDateTime': messageModel.timeSent,
        'imgurl${chatModel.currentUserId}': chatModel.currentUserImageUrl,
        'imgurl${chatModel.otherUserId}': chatModel.otherUserImageUrl,
        'lastMessageSentBy': chatModel.currentUserId,
        'fcmToken${chatModel.currentUserId}': chatModel.currentUserFcmToken,
        'fcmToken${chatModel.otherUserId}': chatModel.otherUserFcmToken,
      });

      var messagesCollectionRef =
          conversationDocRef.collection('messages').doc(messageModel.messageId);

      batch.set(messagesCollectionRef, messageModel.toJson());

      await batch.commit();
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<Map<String, int>> getUnreadMessagesCount() {
    try {
      StreamController<Map<String, int>> unreadMessagesCount =
          StreamController<Map<String, int>>();
      final currentUserId = firebaseAuth.currentUser!.uid;
      Map<String, int> unreadMessagesMap =
          {}; // Map to store unread messages count
      Map<String, Set<String>> processedMessages =
          {}; // Map to store processed message IDs for each user

      // Fetch messages from all chats
      FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .snapshots()
          .listen((chatsSnapshot) async {
        // Iterate through each chat document
        for (DocumentSnapshot chatDoc in chatsSnapshot.docs) {
          FirebaseFirestore.instance
              .collection('chats')
              .doc(chatDoc.id)
              .collection('messages')
              .where('isViewed', isEqualTo: false)
              .snapshots()
              .listen((messageSnapShot) async {
            String otherUser = '';
            for (var messageDoc in messageSnapShot.docs) {
              if (await messageDoc.data()['sentBy'] != currentUserId) {
                otherUser = await messageDoc.data()['sentBy'];
                final messageId = messageDoc.id;
                // Check if this message has already been processed for this user
                if (!processedMessages.containsKey(otherUser) ||
                    !processedMessages[otherUser]!.contains(messageId)) {
                  // If not processed, increment the count and mark as processed
                  processedMessages.putIfAbsent(otherUser, () => <String>{});
                  processedMessages[otherUser]!.add(messageId);
                  unreadMessagesMap[otherUser] =
                      (unreadMessagesMap[otherUser] ?? 0) + 1;
                }
              }
            }
            // Push the updated map to the stream
            unreadMessagesCount.add(unreadMessagesMap);
          });
        }
      });
      log(unreadMessagesCount.stream.toString());
      return unreadMessagesCount.stream;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> markMessagesAsViewed(ChatModel chatModel) async {
    try {
      final messagesRef = firebaseFirestore
          .collection('chats')
          .doc(chatModel.chatId)
          .collection('messages');

// Query for unread messages sent by the other user
      final unreadMessagesQuery = messagesRef
          .where('sentBy', isEqualTo: chatModel.otherUserId)
          .where('isViewed', isEqualTo: false);

// Get the documents from the query
      final unreadMessagesSnapshot = await unreadMessagesQuery.get();

// Loop through each unread message and update its 'viewed' field to true
      for (var doc in unreadMessagesSnapshot.docs) {
        messagesRef.doc(doc.id).update({'isViewed': true});
      }
      return unit;
    } catch (e) {
      print(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> sendApprovedMessage(
      ChatModel chatModel, MessageModel messageModel) async {
    try {
      final res = await firebaseFirestore
          .collection('chats')
          .doc(chatModel.chatId)
          .collection('messages')
          .doc(messageModel.messageId)
          .set({"action": true}, SetOptions(merge: true));
      return (unit);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
