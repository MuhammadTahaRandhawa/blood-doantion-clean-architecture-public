import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';

abstract interface class UserRepository {
  Future<Either<Failure, Unit>> submitUserData(User user);
  Future<Either<Failure, User>> fetchUserData();
  Future<Either<Failure, String>> updateProfileImage(File user);
  Future<Either<Failure, Unit>> updateUserLocation(Location location);
  Future<Either<Failure, Unit>> submitDonationRef(String docRef);
  Future<Either<Failure, Unit>> updateUserFcmToken(String fcmtoken);
  Future<Either<Failure, User>> fetchOtherUserData(String userId);
}
