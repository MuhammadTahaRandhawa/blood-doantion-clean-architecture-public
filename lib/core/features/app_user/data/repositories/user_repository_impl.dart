import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/features/app_user/data/datasource/user_local_data_source.dart';
import 'package:myapp/core/features/app_user/data/datasource/user_remote_data_source.dart';
import 'package:myapp/core/features/app_user/data/models/user_model.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/domain/repositories/user_repoistory.dart';
import 'package:myapp/core/features/location/data/models/location_model.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  final InternetConnection internetConnection;

  UserRepositoryImpl(this.userRemoteDataSource, this.userLocalDataSource,
      this.internetConnection);

  @override
  Future<Either<Failure, User>> fetchUserData() async {
    try {
      if (await internetConnection.hasInternetAccess) {
        final response = await userRemoteDataSource.fetchUserData();
        await userLocalDataSource.submitUserData(response);

        return right(response);
      } else {
        return right(userLocalDataSource.fetchUserData());
      }
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitUserData(User user) async {
    try {
      await userRemoteDataSource.submitUserData(UserModel.fromUser(user));
      await userLocalDataSource.submitUserData(UserModel.fromUser(user));
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfileImage(File image) async {
    try {
      final response = await userRemoteDataSource.submitUserProfileImage(image);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserLocation(Location location) async {
    try {
      final res = await userRemoteDataSource
          .updateUserLocation(LocationModel.fromLocation(location));
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> submitDonationRef(String docRef) async {
    try {
      final response = await userRemoteDataSource.postUserDonationRef(docRef);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserFcmToken(String fcmtoken) async {
    try {
      final res = await userRemoteDataSource.updateUserFcmToken(fcmtoken);
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, User>> fetchOtherUserData(String userId) async {
    try {
      final response = await userRemoteDataSource.fetchOtherUserData(userId);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
