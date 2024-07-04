
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/features/chat/data/models/chat_model.dart';

abstract interface class ChatRemoteDataSource {
  Stream<List<ChatModel>> fethChatsOfCurrentUser();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  ChatRemoteDataSourceImpl(this.firebaseAuth, this.firebaseFirestore);

  @override
  Stream<List<ChatModel>> fethChatsOfCurrentUser() {
    try {
      final currentUserId = firebaseAuth.currentUser!.uid;
      final chats = firebaseFirestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .orderBy('lastMessageDateTime', descending: true)
          .snapshots()
          .map((event) => event.docs
              .map((e) => ChatModel.fromJson(e.data(), firebaseAuth))
              .toList());

      return chats;
    } catch (e, s) {
      print(e);
      print(s);
      throw ServerException(e.toString());
    }
  }
}
