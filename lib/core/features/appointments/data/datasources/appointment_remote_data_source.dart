import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/features/appointments/data/models/appointment_model.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class AppointmentRemoteDataSource {
  Future<List<AppointmentModel>> fetchMyAppointments();
  Future<List<AppointmentModel>> fetchMyInvlovedAppointments();
  Future<Unit> submitAnAppointment(AppointmentModel appointmentModel);
  Future<Unit> updateAppointmentStatus(
      String appointmentId, AppointmentStatus newAppointmentStatus);
  // Future<Unit> submitARequestAppointment(AppointmentModel appointmentModel);
  // Future<Unit> submitADonationAppointment(AppointmentModel appointmentModel);
  Future<Unit> updateAppointmentStatusAndTime(String appointmentId,
      AppointmentStatus newAppointmentStatus, DateTime dateTime);
  Stream<List<AppointmentModel>> fetchStreamOfMyOverallAppointments();
  Future<Unit> updateAppointmentIsCompleted(
      String appointmentId, bool meIsCreater, bool isCompleted);
  Future<AppointmentModel> fetchAppointmentById(String appointmentId);
}

class AppointRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  AppointRemoteDataSourceImpl(this.firebaseFirestore, this.firebaseAuth);
  @override
  Future<List<AppointmentModel>> fetchMyAppointments() async {
    try {
      final res = await firebaseFirestore
          .collection('appointments')
          .where('appointmentCreaterId',
              isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      final myAppointments =
          res.docs.map((e) => AppointmentModel.fromJson(e.data())).toList();
      return myAppointments;
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> submitAnAppointment(AppointmentModel appointmentModel) async {
    try {
      await firebaseFirestore
          .collection('appointments')
          .doc(appointmentModel.appointmentID)
          .set(appointmentModel.toJson());
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // @override
  // Future<Unit> submitADonationAppointment(AppointmentModel appointmentModel) async {
  //   try {
  //     await firebaseFirestore
  //         .collection('appointments')
  //         .doc(appointmentModel.appointmentID)
  //         .set(appointmentModel.toJson());
  //     return unit;
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }

  // @override
  // Future<Unit> submitARequestAppointment(AppointmentModel appointmentModel) {
  //   // TODO: implement submitARequestAppointment
  //   throw UnimplementedError();
  // }

  @override
  Future<Unit> updateAppointmentStatus(
      String appointmentId, AppointmentStatus newAppointmentStatus) async {
    try {
      await firebaseFirestore.collection('appointments').doc(appointmentId).set(
          AppointmentModel.updateAppointmentStatus(newAppointmentStatus),
          SetOptions(merge: true));
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateAppointmentStatusAndTime(String appointmentId,
      AppointmentStatus newAppointmentStatus, DateTime dateTime) async {
    try {
      await firebaseFirestore.collection('appointments').doc(appointmentId).set(
          AppointmentModel.updateAppointmentStatusAndTime(
              newAppointmentStatus, dateTime),
          SetOptions(merge: true));
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AppointmentModel>> fetchMyInvlovedAppointments() async {
    try {
      final res = await firebaseFirestore
          .collection('appointments')
          .where('appointmentParticipantId',
              isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      final myAppointments =
          res.docs.map((e) => AppointmentModel.fromJson(e.data())).toList();
      return myAppointments;
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<AppointmentModel>> fetchStreamOfMyOverallAppointments() {
    try {
      final userId = firebaseAuth.currentUser!.uid;

      final stream1 = firebaseFirestore
          .collection('appointments')
          .where('appointmentCreaterId', isEqualTo: userId)
          .snapshots();

      final stream2 = firebaseFirestore
          .collection('appointments')
          .where('appointmentParticipantId', isEqualTo: userId)
          .snapshots();

      return Rx.combineLatest2<QuerySnapshot, QuerySnapshot,
          List<AppointmentModel>>(
        stream1,
        stream2,
        (snapshot1, snapshot2) {
          final appointments1 = snapshot1.docs
              .map((doc) =>
                  AppointmentModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          final appointments2 = snapshot2.docs
              .map((doc) =>
                  AppointmentModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          // Combine the two lists and remove duplicates if necessary
          final allAppointments = [...appointments1, ...appointments2];

          // // Assuming you want to remove duplicates based on a unique property, e.g., an id
          // final uniqueAppointments = allAppointments.toSet().toList();
          // log('inside data $uniqueAppointments');
          return allAppointments;
        },
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> updateAppointmentIsCompleted(
      String appointmentId, bool meIsCreater, bool isCompleted) async {
    try {
      await firebaseFirestore.collection('appointments').doc(appointmentId).set(
          meIsCreater
              ? {'createrIsCompleted': isCompleted}
              : {'participantIsCompleted': isCompleted},
          SetOptions(merge: true));
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppointmentModel> fetchAppointmentById(String appointmentId) async {
    try {
      final res = await firebaseFirestore
          .collection('appointments')
          .doc(appointmentId)
          .get();
      if (res.exists) {
        return AppointmentModel.fromJson(res.data()!);
      } else {
        throw ServerException('appointment does not exist');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
