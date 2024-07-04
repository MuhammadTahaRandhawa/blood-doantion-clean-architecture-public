import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/maps/domain/repository/maps_repository.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

class FetchMapsStaticImage {
  final MapsRepository repository;

  FetchMapsStaticImage(this.repository);

  Either<Failure, Image> call(LatitudeLongitude params) {
    return repository.fetchMapsStaticImage(params);
  }
}
