import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';
import 'package:myapp/features/blood_centers/domain/repository/blood_center_repository.dart';

class FetchBloodCentersAroundUser
    implements Usecase<List<BloodCenter>, LatitudeLongitude> {
  final BloodCenterRepository bloodCenterRepository;

  FetchBloodCentersAroundUser(this.bloodCenterRepository);
  @override
  Future<Either<Failure, List<BloodCenter>>> call(params) async {
    return await bloodCenterRepository.fetchBloodCentersAroundUser(params);
  }
}
