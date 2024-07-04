import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/usecase/usecase.dart';

class UpdateUserLocationToServer implements Usecase<Unit, Location> {
  final UserRepository userRepository;

  UpdateUserLocationToServer(this.userRepository);
  @override
  Future<Either<Failure, Unit>> call(Location params) async {
    return await userRepository.updateUserLocation(params);
  }
}
