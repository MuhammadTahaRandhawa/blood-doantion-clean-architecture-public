import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

abstract interface class LocationRepository {
  Future<Either<Failure, Unit>> getCurrentLocationPermissions();
  Future<Either<Failure, Position>> getCurrentPosition();
  Future<Either<Failure, String>> getCurrentAddress(
      LatitudeLongitude latitudeLongitude);
  Future<Either<Failure, Location>> getCurrentLocation();
}
