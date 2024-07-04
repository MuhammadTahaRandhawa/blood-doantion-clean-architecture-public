import 'dart:developer';

import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_map/data/datasources/blood_map_remote_data_source.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:myapp/features/blood_map/domain/repositories/bloodmap_repository.dart';

class BloodMapRepositoryImpl implements BloodMapRepository {
  final BloodMapRemoteDataSource bloodMapRemoteDataSource;

  BloodMapRepositoryImpl(this.bloodMapRemoteDataSource);
  @override
  Future<Either<Failure, List<MapMarker>>> fetchDonationsMarkersAroundUser(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final response = await bloodMapRemoteDataSource
          .fetchDonationsMapMarkersAroundUser(latitudeLongitude);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<MapMarker>>> fetchRequestsMarkersAroundUser(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final response = await bloodMapRemoteDataSource
          .fetchRequestsMapMarkersAroundUser(latitudeLongitude);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<MapMarker>>> fetchCentersMarkersAroundUser(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final response = await bloodMapRemoteDataSource
          .fetchCentersMapMarkersAroundUser(latitudeLongitude);
      log('fetchCentersMarkersAroundUser' + response.toString());
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
