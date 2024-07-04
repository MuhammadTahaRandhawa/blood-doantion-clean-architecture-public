import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/usecase/usecase.dart';

class UpdateUserFcmToken implements Usecase<Unit, String> {
  final UserRepository userRepository;

  UpdateUserFcmToken(this.userRepository);
  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await userRepository.updateUserFcmToken(params);
  }
}
