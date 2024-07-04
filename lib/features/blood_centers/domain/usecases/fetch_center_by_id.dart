import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';
import 'package:myapp/features/blood_centers/domain/repository/blood_center_repository.dart';

class FetchCenterById implements Usecase<BloodCenter, String> {
  final BloodCenterRepository bloodCenterRepository;

  FetchCenterById(this.bloodCenterRepository);
  @override
  Future<Either<Failure, BloodCenter>> call(String params) async {
    return await bloodCenterRepository.fetchBloodCenterById(params);
  }
}
