import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/usecase/usecase.dart';

class SubmitUserProfileImage implements Usecase<String, File> {
  final UserRepository userRepository;

  SubmitUserProfileImage(this.userRepository);
  @override
  Future<Either<Failure, String>> call(File params) async {
    return await userRepository.updateProfileImage(params);
  }
}
