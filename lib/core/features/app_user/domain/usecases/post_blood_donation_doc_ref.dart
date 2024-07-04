import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/usecase/usecase.dart';

class PostBloodDonationDocRef implements Usecase<Unit, String> {
  final UserRepository userRepository;

  PostBloodDonationDocRef(this.userRepository);
  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await userRepository.submitDonationRef(params);
  }
}
