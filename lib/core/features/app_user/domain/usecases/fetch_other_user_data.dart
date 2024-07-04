import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/usecase/usecase.dart';

class FetchOtherUserData implements Usecase<User, String> {
  final UserRepository userRepository;

  FetchOtherUserData(this.userRepository);
  @override
  Future<Either<Failure, User>> call(String params) async {
    return await userRepository.fetchOtherUserData(params);
  }
}
