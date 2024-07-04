import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_requests/data/datamodels/request_model.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';

abstract interface class BloodRequestsRemoteDataSource {
  Future<Unit> submitANewRequest(RequestModel requestModel);
  Future<List<RequestModel>> fetchRequests();
  Stream<List<RequestModel>> streamOfRequestsInCertainRadius(
      LatitudeLongitude latitudeLongitude);
  Future<List<Request>> fetchMyRequests();
  Future<List<RequestModel>> fetchRequestsInCertainRadius(
    LatitudeLongitude latitudeLongitude,
  );
  Future<RequestModel> fetchRequestById(String requestId);
}

class BloodRequestsRemoteDataSourceImpl
    implements BloodRequestsRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  BloodRequestsRemoteDataSourceImpl(this.firebaseFirestore, this.firebaseAuth);

  @override
  Future<List<RequestModel>> fetchRequests() async {
    try {
      final response =
          await firebaseFirestore.collection('requests').limit(50).get();
      final List<RequestModel> requestList = [];
      for (var request in response.docs) {
        requestList.add(RequestModel.fromJson(request.data()));
      }
      return requestList;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RequestModel>> fetchRequestsInCertainRadius(
    LatitudeLongitude latitudeLongitude,
  ) async {
    try {
      final today = DateTime.now();
      final requestsCollection = firebaseFirestore.collection('requests');
      final geo = GeoFlutterFire();
      final center = geo.point(
        latitude: latitudeLongitude.latitude,
        longitude: latitudeLongitude.longitude,
      );

      final stream = geo.collection(collectionRef: requestsCollection).within(
            center: center,
            radius: 32,
            field: 'position',
            strictMode: true,
          );

      final fetchedData = await stream.first; // Get all documents at once

      // Filter and map as before
      final requests = fetchedData
          .map((e) {
            final request = e.data() as Map<String, dynamic>;
            if (today.difference(request['requestDateTime'].toDate()).inDays <
                7) {
              return RequestModel.fromJson(request);
            }
            return null;
          })
          .whereType<RequestModel>()
          .toList();
      return requests;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> submitANewRequest(RequestModel requestModel) async {
    try {
      await firebaseFirestore
          .collection('requests')
          .doc(requestModel.requestId)
          .set(requestModel.toJson());
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<RequestModel>> streamOfRequestsInCertainRadius(
      LatitudeLongitude latitudeLongitude) {
    try {
      final today = DateTime.now();
      final requestsCollection = firebaseFirestore.collection('requests');
      final geo = GeoFlutterFire();
      GeoFirePoint center = geo.point(
          latitude: latitudeLongitude.latitude,
          longitude: latitudeLongitude.longitude);
      return geo
          .collection(collectionRef: requestsCollection)
          .within(
            center: center,
            radius: 32,
            field: 'position',
            strictMode: true,
          )
          .map((List<DocumentSnapshot> docList) {
        return docList
            .map((DocumentSnapshot doc) {
              final request = doc.data() as Map<String, dynamic>;
              if (today.difference(request['requestDateTime'].toDate()).inDays <
                  7) {
                return RequestModel.fromJson(request);
              }
              return null; // This will be filtered out
            })
            .whereType<RequestModel>()
            .toList(); // Filter out null values
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Request>> fetchMyRequests() async {
    try {
      final res = await firebaseFirestore
          .collection('requests')
          .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
          .orderBy('requestDateTime', descending: true)
          .get();
      final myRequests =
          res.docs.map((e) => RequestModel.fromJson(e.data())).toList();
      return myRequests;
    } catch (e) {
      // print(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RequestModel> fetchRequestById(String requestId) async {
    try {
      log('request id: $requestId');
      final response =
          await firebaseFirestore.collection('requests').doc(requestId).get();
      if (response.exists) {
        return RequestModel.fromJson(response.data()!);
      } else {
        log('request does not exist');
        throw ServerException('request does not exist');
      }
    } catch (e, stack) {
      log(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }
}
