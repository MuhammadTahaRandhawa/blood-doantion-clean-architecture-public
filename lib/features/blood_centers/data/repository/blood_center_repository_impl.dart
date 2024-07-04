import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_centers/data/datasource/center_remote_datasource.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';
import 'package:myapp/features/blood_centers/domain/repository/blood_center_repository.dart';

class BloodCenterRepositoryImpl implements BloodCenterRepository {
  final CenterRemoteDataSource centerRemoteDataSource;

  BloodCenterRepositoryImpl(this.centerRemoteDataSource);
  @override
  Future<Either<Failure, List<BloodCenter>>> fetchBloodCentersAroundUser(
      LatitudeLongitude latitudeLongitude) async {
    try {
      final res = await centerRemoteDataSource
          .fetchBloodCentersAroundUser(latitudeLongitude);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, BloodCenter>> fetchBloodCenterById(String id) async {
    try {
      final response = await centerRemoteDataSource.fetchBloodCenterById(id);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }
}
