import 'package:myapp/core/features/location/domain/entities/location.dart';

class BloodCenter {
  final String centerId;
  final String centerName;
  final String centerPhoneNo;
  final String centerEmail;
  final Map<CenterOpertaingTimeType, String> centerOpertaingTime;
  final Location centerLocation;

  BloodCenter(this.centerEmail,
      {required this.centerId,
      required this.centerName,
      required this.centerLocation,
      required this.centerOpertaingTime,
      required this.centerPhoneNo});
}

enum CenterOpertaingTimeType { startingTime, closingTime }
