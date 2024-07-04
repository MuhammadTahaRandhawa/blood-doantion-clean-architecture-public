import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/location/domain/repository/location_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class GetCurrentPosition implements Usecase<Position, Unit> {
  final LocationRepository locationRepository;
  GetCurrentPosition(this.locationRepository);
  @override
  Future<Either<Failure, Position>> call(Unit params) async {
    return await locationRepository.getCurrentPosition();
  }
}
