import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_centers/data/model/blood_center_model.dart';

abstract interface class CenterRemoteDataSource {
  Future<List<BloodCenterModel>> fetchBloodCentersAroundUser(
    LatitudeLongitude latitudeLongitude,
  );
  Future<BloodCenterModel> fetchBloodCenterById(String centerId);
}

class CenterRemoteDataSourceImpl implements CenterRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  CenterRemoteDataSourceImpl(this.firebaseFirestore);
  @override
  Future<List<BloodCenterModel>> fetchBloodCentersAroundUser(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final donationsCollection = firebaseFirestore.collection('centers');
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
      final centers = fetchedData.map((e) {
        final center = e.data() as Map<String, dynamic>;
        return BloodCenterModel.fromJson(center);
      }).toList();

      return centers;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BloodCenterModel> fetchBloodCenterById(String centerId) async {
    try {
      final response =
          await firebaseFirestore.collection('centers').doc(centerId).get();
      if (response.exists) {
        return BloodCenterModel.fromJson(response.data()!);
      } else {
        throw ServerException('center does not exist');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
