import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/location/domain/repository/location_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';

class GetLocationPermission implements Usecase {
  final LocationRepository locationRepository;
  GetLocationPermission(this.locationRepository);
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await locationRepository.getCurrentLocationPermissions();
  }
}
