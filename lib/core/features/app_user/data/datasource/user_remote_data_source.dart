import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/features/app_user/data/models/user_model.dart';
import 'package:myapp/core/features/location/data/models/location_model.dart';

abstract interface class UserRemoteDataSource {
  Future<Unit> submitUserData(UserModel userModel);
  Future<UserModel> fetchUserData();
  Future<String> submitUserProfileImage(File image);
  Future<Unit> updateUserLocation(LocationModel location);
  Future<Unit> postUserDonationRef(String docRef);
  Future<Unit> updateUserFcmToken(String fcmToken);
  Future<UserModel> fetchOtherUserData(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;

  UserRemoteDataSourceImpl(
      this.firebaseFirestore, this.firebaseAuth, this.firebaseStorage);

  @override
  Future<UserModel> fetchUserData() async {
    try {
      final response = await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      return UserModel.fromJson(response.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> submitUserData(UserModel userModel) async {
    try {
      final response = await firebaseFirestore
          .collection('users')
          .doc(userModel.userId)
          .set(userModel.toJson(), SetOptions(merge: true));
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> submitUserProfileImage(File image) async {
    try {
      final userId = firebaseAuth.currentUser!.uid;
      final storageRef =
          firebaseStorage.ref().child('user_images').child('$userId.jpg');

      await storageRef.putFile(image);

      final imageUrl = await storageRef.getDownloadURL();

      return imageUrl;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateUserLocation(LocationModel location) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(location.toJson(location), SetOptions(merge: true));
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> postUserDonationRef(String docRef) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc('donations')
          .collection(docRef)
          .add({'donationRef': docRef, 'dateTime': DateTime.now()});
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateUserFcmToken(String fcmToken) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set({'fcmToken': fcmToken}, SetOptions(merge: true));
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> fetchOtherUserData(String userId) async {
    try {
      final response =
          await firebaseFirestore.collection('users').doc(userId).get();
      return UserModel.fromJson(response.data()!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
