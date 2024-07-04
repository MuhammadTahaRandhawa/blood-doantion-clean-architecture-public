import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:myapp/features/blood_map/domain/repositories/bloodmap_repository.dart';

class FetchRequestsMapsMarkersAroundUser
    implements Usecase<List<MapMarker>, LatitudeLongitude> {
  final BloodMapRepository bloodMapRepository;

  FetchRequestsMapsMarkersAroundUser(this.bloodMapRepository);
  @override
  Future<Either<Failure, List<MapMarker>>> call(
      LatitudeLongitude params) async {
    return await bloodMapRepository.fetchRequestsMarkersAroundUser(params);
  }
}
