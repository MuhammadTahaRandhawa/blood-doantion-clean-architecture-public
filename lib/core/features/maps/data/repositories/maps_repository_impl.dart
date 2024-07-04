import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/maps/data/datasources/maps_datasources.dart';
import 'package:myapp/core/features/maps/domain/repository/maps_repository.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

class MapsRepositoryImpl implements MapsRepository {
  final MapsDataSource mapsDataSource;

  MapsRepositoryImpl(this.mapsDataSource);
  @override
  Either<Failure, Image> fetchMapsStaticImage(
      LatitudeLongitude latitudeLongitude) {
    try {
      return right(mapsDataSource.fetchMapsStaticImage(latitudeLongitude));
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
