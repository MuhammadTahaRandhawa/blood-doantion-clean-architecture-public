import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_donations/data/datamodel/donation_model.dart';

abstract interface class BloodDonationDataSources {
  Future<String> postANewDonation(DonationModel donationModel);

  Future<Unit> turnOffADonation(DonationModel donationModel);

  Future<List<DonationModel>> fetchDonations();

  Stream<List<DonationModel>> streamOfDonationsInCertainRadius(
      LatitudeLongitude latitudeLongitude);

  Future<List<DonationModel>> fetchDonationsInCertainRadius(
    LatitudeLongitude latitudeLongitude,
  );
  Future<DonationModel> fetchDonationById(String donationId);
  Future<List<DonationModel>> fetchMyDonations();
}

class BloodDonationDataSourcesImpl implements BloodDonationDataSources {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  BloodDonationDataSourcesImpl(this.firebaseFirestore, this.firebaseAuth);
  @override
  Future<List<DonationModel>> fetchDonations() async {
    try {
      List<DonationModel> donations = [];
      final response =
          await firebaseFirestore.collection('users').limit(50).get();

      for (var donation in response.docs) {
        donations.add(DonationModel.fromJson(donation.data()));
      }

      return donations;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> postANewDonation(DonationModel donationModel) async {
    try {
      await firebaseFirestore
          .collection('donations')
          .doc(donationModel.donationId)
          .set(donationModel.toJson());
      return donationModel.donationId;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<DonationModel>> streamOfDonationsInCertainRadius(
      LatitudeLongitude latitudeLongitude) {
    try {
      final donationsCollection = firebaseFirestore.collection('donations');
      final geo = GeoFlutterFire();
      GeoFirePoint center = geo.point(
          latitude: latitudeLongitude.latitude,
          longitude: latitudeLongitude.longitude);
      return geo
          .collection(collectionRef: donationsCollection)
          .within(
            center: center,
            radius: 32,
            field: 'position',
            strictMode: true,
          )
          .map((List<DocumentSnapshot> docList) {
        return docList
            .map((DocumentSnapshot doc) =>
                DonationModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DonationModel>> fetchDonationsInCertainRadius(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final donationsCollection = firebaseFirestore.collection('donations');
      final geo = GeoFlutterFire();
      final center = geo.point(
        latitude: latitudeLongitude.latitude,
        longitude: latitudeLongitude.longitude,
      );

      final stream = geo.collection(collectionRef: donationsCollection).within(
            center: center,
            radius: 32,
            field: 'position',
            strictMode: true,
          );

      final fetchedData = await stream.first; // Get all documents at once

      // Filter and map as before
      final donations = fetchedData
          .map((e) {
            final donation = e.data() as Map<String, dynamic>;
            return DonationModel.fromJson(donation);
          })
          .where((element) => element.isActive)
          .toList();

      return donations;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<DonationModel> fetchDonationById(String donationId) async {
    try {
      final response =
          await firebaseFirestore.collection('donations').doc(donationId).get();
      if (response.exists) {
        return DonationModel.fromJson(response.data()!);
      } else {
        throw ServerException('donation does not exist');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> turnOffADonation(DonationModel donationModel) async {
    try {
      await firebaseFirestore
          .collection('donations')
          .doc(donationModel.donationId)
          .set({"isActive": false});
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<DonationModel>> fetchMyDonations() async {
    try {
      final response = await firebaseFirestore
          .collection('donations')
          .where("userId", isEqualTo: firebaseAuth.currentUser!.uid)
          .get();
      final myDonations =
          response.docs.map((e) => DonationModel.fromJson(e.data())).toList();
      return myDonations;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
