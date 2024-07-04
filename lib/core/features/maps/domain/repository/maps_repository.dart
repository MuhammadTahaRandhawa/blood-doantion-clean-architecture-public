import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

abstract interface class MapsRepository {
  Either<Failure, Image> fetchMapsStaticImage(
      LatitudeLongitude latitudeLongitude);
}
