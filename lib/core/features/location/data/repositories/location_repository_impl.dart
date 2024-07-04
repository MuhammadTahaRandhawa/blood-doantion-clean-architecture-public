import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/location/data/datasource/location_datasource.dart';
import 'package:myapp/core/features/location/data/models/location_model.dart';
import 'package:myapp/core/features/location/domain/repository/location_repository.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource locationDataSource;
  LocationRepositoryImpl(this.locationDataSource);
  @override
  Future<Either<Failure, LocationModel>> getCurrentLocation() async {
    try {
      final location = await locationDataSource.getCurrentLocation();
      return right(location);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> getCurrentLocationPermissions() async {
    try {
      final response = await locationDataSource.getLocationPermission();

      return right(unit);
    } on ServerException catch (e) {
      return left(Failure((e.exceptionMessage)));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentAddress(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final address =
          await locationDataSource.getCurrentAddress(latitudeLongitude);
      return right(address);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Position>> getCurrentPosition() async {
    try {
      final currentPosition = await locationDataSource.getCurrentPosition();
      return right(currentPosition);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
