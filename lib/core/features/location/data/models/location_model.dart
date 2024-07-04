import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

class LocationModel extends Location {
  LocationModel(
      {required super.latitude,
      required super.longitude,
      required super.address});

  Map<String, dynamic> toJson(LocationModel locationModel) {
    return {
      'position': GeoFlutterFireConversion.toFirePoint(
              locationModel.latitude, locationModel.longitude)
          .data,
      'address': locationModel.address,
    };
  }

  factory LocationModel.fromLocation(Location location) {
    return LocationModel(
        address: location.address,
        latitude: location.latitude,
        longitude: location.longitude);
  }
}
