import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/usecase/usecase.dart';

class FetchUserDataRemotly implements Usecase<User, Unit> {
  final UserRepository userRepository;

  FetchUserDataRemotly(this.userRepository);

  @override
  Future<Either<Failure, User>> call(Unit params) async {
    return await userRepository.fetchUserData();
  }
}
