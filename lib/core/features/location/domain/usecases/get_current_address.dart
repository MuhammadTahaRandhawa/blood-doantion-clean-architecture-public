import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/location/domain/repository/location_repository.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';

class GetCurrentAddress implements Usecase<String, LatitudeLongitude> {
  final LocationRepository locationRepository;
  GetCurrentAddress(this.locationRepository);
  @override
  Future<Either<Failure, String>> call(LatitudeLongitude params) async {
    return await locationRepository.getCurrentAddress(params);
  }
}
