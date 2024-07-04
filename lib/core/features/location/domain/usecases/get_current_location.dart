import 'package:fpdart/fpdart.dart';

import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/features/location/domain/repository/location_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class GetCurrentLocation implements Usecase<Location, Unit> {
  final LocationRepository locationRepository;
  GetCurrentLocation(this.locationRepository);
  @override
  Future<Either<Failure, Location>> call(params) async {
    return await locationRepository.getCurrentLocation();
  }
}
