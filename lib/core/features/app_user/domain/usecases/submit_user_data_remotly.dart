import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/domain/helpers/submit_user_data_params.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/usecase/usecase.dart';

class SubmitUserDataRemotly implements Usecase<Unit, SubmitUserDataParams> {
  final UserRepository userRepository;

  SubmitUserDataRemotly(this.userRepository);

  @override
  Future<Either<Failure, Unit>> call(SubmitUserDataParams params) async {
    return await userRepository.submitUserData(params.userFromParams());
  }
}
