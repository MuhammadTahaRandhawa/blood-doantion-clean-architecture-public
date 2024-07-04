import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';

abstract interface class BloodMapRepository {
  // Either<Failure, Stream<MapMarker>> fetchRequestsMarkers();
  // Either<Failure, Stream<MapMarker>> fetchDonationsMarkers();
  Future<Either<Failure, List<MapMarker>>> fetchRequestsMarkersAroundUser(
      LatitudeLongitude latitudeLongitude);
  Future<Either<Failure, List<MapMarker>>> fetchDonationsMarkersAroundUser(
      LatitudeLongitude latitudeLongitude);

  Future<Either<Failure, List<MapMarker>>> fetchCentersMarkersAroundUser(
      LatitudeLongitude latitudeLongitude);
}
