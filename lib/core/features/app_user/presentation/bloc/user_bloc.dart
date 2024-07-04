import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/domain/helpers/submit_user_data_params.dart';
import 'package:myapp/core/features/app_user/domain/usecases/fetch_other_user_data.dart';
import 'package:myapp/core/features/app_user/domain/usecases/fetch_user_data_remotly.dart';
import 'package:myapp/core/features/app_user/domain/usecases/post_blood_donation_doc_ref.dart';
import 'package:myapp/core/features/app_user/domain/usecases/submit_user_data_remotly.dart';
import 'package:myapp/core/features/app_user/domain/usecases/submit_user_profile_image.dart';
import 'package:myapp/core/features/app_user/domain/usecases/update_user_fcm_token.dart';
import 'package:myapp/core/features/app_user/domain/usecases/update_user_location_to_server.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SubmitUserDataRemotly submitUserDataRemotly;
  final FetchUserDataRemotly fetchUserDataRemotly;
  final SubmitUserProfileImage submitUserProfileImage;
  final UpdateUserLocationToServer updateUserLocationToServer;
  final PostBloodDonationDocRef postBloodDonationDocRef;
  final UpdateUserFcmToken updateUserFcmToken;
  final FetchOtherUserData fetchOtherUserData;

  UserBloc(
      this.submitUserDataRemotly,
      this.fetchUserDataRemotly,
      this.submitUserProfileImage,
      this.updateUserLocationToServer,
      this.postBloodDonationDocRef,
      this.updateUserFcmToken,
      this.fetchOtherUserData)
      : super(UserInitial()) {
    on<UserDataSubmittedRemotly>(userDataSubmittedRemotly);
    on<UserDataFetchedRemotly>(userDataFetchedRemotly);
    on<UserProfileImageSubmitted>(userProfileImageSubmitted);
    on<UserLocationUpdated>(userLocationUpdated);
    on<BloodDonationDocRefPosted>(bloodDonationDocRefPosted);
    on<UserFcmTokenUpdated>(userFcmTokenUpdated);
    on<OtherUserDataFethed>(otherUserDataFethed);
  }

  userDataSubmittedRemotly(UserDataSubmittedRemotly event, Emitter emit) async {
    emit(UserSubmittedLoading());
    final response = await submitUserDataRemotly.call(SubmitUserDataParams(
        userId: event.user.userId,
        email: event.user.email,
        userName: event.user.userName,
        dob: event.user.dob,
        phoneNo: event.user.phoneNo,
        cnic: event.user.cnic,
        gender: event.user.gender,
        bloodGroup: event.user.bloodGroup,
        location: event.user.location,
        fcmToken: event.user.fcmToken,
        userProfileImageUrl: event.user.userProfileImageUrl));

    response.fold((l) => emit(UserSubmittedFailure(l.message)),
        (r) => emit(UserSubmittedSuccess()));
  }

  userDataFetchedRemotly(UserDataFetchedRemotly event, Emitter emit) async {
    emit(UserFetchedLoading());
    final response = await fetchUserDataRemotly.call(unit);
    response.fold((l) => emit(UserFetchedFailure(l.message)),
        (r) => emit(UserFetchedSuccess(r)));
  }

  void userProfileImageSubmitted(
      UserProfileImageSubmitted event, Emitter emit) async {
    emit(UserSubmittedLoading());
    final response = await submitUserProfileImage.call(event.profileImage);
    response.fold((l) => emit(UserProfileImageSubmitFailure(l.message)),
        (r) => emit(UserProfileImageSubmitSuccess(r)));
  }

  void userLocationUpdated(UserLocationUpdated event, Emitter emit) async {
    final res = await updateUserLocationToServer.call(event.location);
    res.fold((l) => emit(UserLocationUpdatedFailure(l.message)),
        (r) => emit(UserLocationUpdatedSuccess()));
  }

  void bloodDonationDocRefPosted(
      BloodDonationDocRefPosted event, Emitter emit) async {
    final response = await postBloodDonationDocRef.call(event.docRef);
    response.fold((l) => emit(BloodDonationDocRefPostFailure(l.message)),
        (r) => emit(BloodDonationDocRefPostSuccess()));
  }

  void userFcmTokenUpdated(UserFcmTokenUpdated event, Emitter emit) async {
    final res = await updateUserFcmToken.call(event.fcmToken);
    res.fold((l) => emit(UserFcmTokenUpdatedFailure(l.message)),
        (r) => emit(UserLocationUpdatedSuccess()));
  }

  void otherUserDataFethed(OtherUserDataFethed event, Emitter emit) async {
    emit(OtherUserDataFetchedLoading());
    final res = await fetchOtherUserData.call(event.userId);
    res.fold((l) => emit(OtherUserDataFetchedFailure(l.message)),
        (r) => emit(OtherUserDataFetchedSuccess(r)));
  }

  @override
  void onTransition(Transition<UserEvent, UserState> transition) {
    super.onTransition(transition);
    if (kDebugMode) {
      print(transition);
    }
  }
}
