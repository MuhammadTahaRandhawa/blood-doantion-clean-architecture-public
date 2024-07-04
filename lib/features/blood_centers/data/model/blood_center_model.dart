import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';

class BloodCenterModel extends BloodCenter {
  BloodCenterModel(super.centerEmail,
      {required super.centerId,
      required super.centerName,
      required super.centerLocation,
      required super.centerOpertaingTime,
      required super.centerPhoneNo});

  factory BloodCenterModel.fromJson(Map<String, dynamic> map) {
    final GeoPoint geoPoint = map['position']['geopoint'];
    final latitudeLongitude = GeoFlutterFireConversion.fromGeoPoint(geoPoint);
    return BloodCenterModel(map['centerEmail'],
        centerId: map['centerId'],
        centerName: map['centerName'],
        centerLocation: Location(
            latitude: latitudeLongitude.latitude,
            longitude: latitudeLongitude.longitude,
            address: map['centerAddress'] ?? 'address'),
        centerOpertaingTime: {
          CenterOpertaingTimeType.startingTime: map['openingTime'],
          CenterOpertaingTimeType.closingTime: map['closingTime'],
        },
        centerPhoneNo: map['centerPhone']);
  }
}
