import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';

class UserCubit extends Cubit<User> {
  UserCubit()
      : super(User(
            userId: '',
            userName: '',
            dob: DateTime.now(),
            phoneNo: '',
            email: '',
            cnic: '',
            gender: '',
            bloodGroup: '',
            location: Location(address: '', latitude: 0.0, longitude: 0)));

  void initializeUser(User user) {
    emit(user);
  }

  void updateUserLocation(Location location) {
    emit(User(
        userId: state.userId,
        userName: state.userName,
        dob: state.dob,
        phoneNo: state.phoneNo,
        email: state.email,
        cnic: state.cnic,
        gender: state.gender,
        bloodGroup: state.bloodGroup,
        location: location,
        fcmToken: state.fcmToken,
        userProfileImageUrl: state.userProfileImageUrl));
  }
}
