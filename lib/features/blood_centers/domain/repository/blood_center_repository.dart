import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';

abstract interface class BloodCenterRepository {
  Future<Either<Failure, List<BloodCenter>>> fetchBloodCentersAroundUser(
      LatitudeLongitude latitudeLongitude);
  Future<Either<Failure, BloodCenter>> fetchBloodCenterById(String id);
}
