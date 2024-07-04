import 'package:fpdart/fpdart.dart';

import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';

abstract interface class BloodRequestRepository {
  Future<Either<Failure, List<Request>>> fetchRequests();
  Future<Either<Failure, Unit>> postANewRequest(Request request);
  Either<Failure, Stream<List<Request>>> streamOfRequestsInCertainRadius(
      LatitudeLongitude latitudeLongitude);
  Future<Either<Failure, List<Request>>> fetchMyRequests();
  Future<Either<Failure, List<Request>>> fetchRequestsInCertainRadius(
      LatitudeLongitude latitudeLongitude);
  Future<Either<Failure, Request>> fetchRequestById(String id);
}
