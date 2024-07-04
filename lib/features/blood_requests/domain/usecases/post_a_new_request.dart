import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/domain/repository/blood_request_repository.dart';

class PostANewBloodRequest implements Usecase<Unit, Request> {
  final BloodRequestRepository bloodRequestRepository;

  PostANewBloodRequest(this.bloodRequestRepository);

  @override
  Future<Either<Failure, Unit>> call(Request params) async {
    return await bloodRequestRepository.postANewRequest(Request(
        userId: params.userId,
        requesterName: params.requesterName,
        phoneNo: params.phoneNo,
        hospital: params.hospital,
        location: params.location,
        requestDateTime: params.requestDateTime,
        bloodGroup: params.bloodGroup,
        bloodBags: params.bloodBags,
        fcmToken: params.fcmToken,
        isActive: params.isActive,
        rating: params.rating,
        userProfileImageUrl: params.userProfileImageUrl,
        requestCase: params.requestCase));
  }
}

// class RequestParams {
//   final String userId;
//   final String requesterName;
//   final String phoneNo;
//   final String? hospital;
//   final Location location;
//   final DateTime requestDateTime;
//   final String bloodGroup;

//   RequestParams(
//       {required this.userId,
//       required this.requesterName,
//       required this.phoneNo,
//       required this.hospital,
//       required this.location,
//       required this.requestDateTime,
//       required this.bloodGroup});
// }
