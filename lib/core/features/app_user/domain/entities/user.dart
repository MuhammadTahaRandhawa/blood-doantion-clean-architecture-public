import 'package:myapp/core/features/location/domain/entities/location.dart';

class User {
  final String _userId;
  final String _userName;
  final DateTime _dob;
  final String _phoneNo;
  final String? _userProfileImageUrl;
  final String _email;
  final String _cnic;
  final String _gender;
  final String _bloodGroup;
  final Location _location;
  final String? _fcmToken;

  User({
    required String userId,
    required String userName,
    required DateTime dob,
    required String phoneNo,
    required String email,
    required String cnic,
    required String gender,
    required String bloodGroup,
    required Location location,
    String? fcmToken,
    String? userProfileImageUrl,
  })  : _userId = userId,
        _userName = userName,
        _dob = dob,
        _phoneNo = phoneNo,
        _userProfileImageUrl = userProfileImageUrl,
        _email = email,
        _cnic = cnic,
        _gender = gender,
        _bloodGroup = bloodGroup,
        _location = location,
        _fcmToken = fcmToken;

  String get userId => _userId;
  String get userName => _userName;
  DateTime get dob => _dob;
  String get phoneNo => _phoneNo;
  String get email => _email;
  String get cnic => _cnic;
  String get gender => _gender;
  String get bloodGroup => _bloodGroup;
  Location get location => _location;
  String? get userProfileImageUrl => _userProfileImageUrl;
  String? get fcmToken => _fcmToken;
}
