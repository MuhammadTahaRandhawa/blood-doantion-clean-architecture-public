import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:myapp/core/error/exceptions.dart';

import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_requests/data/datamodels/request_model.dart';
import 'package:myapp/features/blood_requests/data/datasources/blood_request_remote_data_source.dart';
import 'package:myapp/features/blood_requests/data/datasources/blood_requests_local_data_source.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/domain/repository/blood_request_repository.dart';

class BloodRequestRepositoryImpl implements BloodRequestRepository {
  final BloodRequestsRemoteDataSource bloodRequestsRemoteDataSource;
  final BloodRequestsLocalDataSource bloodRequestsLocalDataSource;

  final InternetConnection internetConnection;

  BloodRequestRepositoryImpl(this.bloodRequestsRemoteDataSource,
      this.internetConnection, this.bloodRequestsLocalDataSource);

  @override
  Future<Either<Failure, List<Request>>> fetchRequests() async {
    try {
      if (await internetConnection.hasInternetAccess) {
        final response = await bloodRequestsRemoteDataSource.fetchMyRequests();
        for (var res in response) {
          log('inside loop');
          await bloodRequestsLocalDataSource
              .storeSingleBloodRequestLocally(RequestModel.fromRequest(res));
        }
        return right(response);
      } else {
        return right(bloodRequestsLocalDataSource.fetchBloodRequestsLocally());
      }
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> postANewRequest(Request request) async {
    try {
      final response = await bloodRequestsRemoteDataSource
          .submitANewRequest(RequestModel.fromRequest(request));
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Either<Failure, Stream<List<Request>>> streamOfRequestsInCertainRadius(
      LatitudeLongitude latitudeLongitude) {
    try {
      final response = bloodRequestsRemoteDataSource
          .streamOfRequestsInCertainRadius(latitudeLongitude);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Request>>> fetchMyRequests() async {
    try {
      final res = await bloodRequestsRemoteDataSource.fetchMyRequests();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, List<Request>>> fetchRequestsInCertainRadius(
      LatitudeLongitude latitudeLongitude) async {
    try {
      if (await internetConnection.hasInternetAccess) {
        final res = await bloodRequestsRemoteDataSource
            .fetchRequestsInCertainRadius(latitudeLongitude);
        for (var i in res) {
          await bloodRequestsLocalDataSource
              .storeSingleBloodRequestLocally(RequestModel.fromRequest(i));
        }
        return right(res);
      } else {
        return right(bloodRequestsLocalDataSource.fetchBloodRequestsLocally());
      }
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Request>> fetchRequestById(String id) async {
    try {
      final response = await bloodRequestsRemoteDataSource.fetchRequestById(id);
      return right(response);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }
}
