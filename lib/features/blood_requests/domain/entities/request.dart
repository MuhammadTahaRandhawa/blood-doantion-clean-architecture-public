import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Request {
  final String requestId;
  final String userId;
  final String requesterName;
  final String phoneNo;
  final String? hospital;
  final Location location;
  final DateTime requestDateTime;
  final String bloodGroup;
  final int rating;
  final String? fcmToken;
  final AppointmentCase requestCase;
  final int bloodBags;
  final bool isActive;
  final String? userProfileImageUrl;

  Request(
      {String? requestId,
      required this.userId,
      required this.requesterName,
      required this.phoneNo,
      required this.hospital,
      required this.location,
      required this.requestDateTime,
      required this.bloodGroup,
      required this.bloodBags,
      required this.fcmToken,
      required this.isActive,
      required this.rating,
      required this.userProfileImageUrl,
      required this.requestCase})
      : requestId = requestId ?? uuid.v4();
}
