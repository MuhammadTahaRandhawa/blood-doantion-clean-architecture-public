import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/core/features/app_user/domain/helpers/submit_user_data_params.dart';
import 'package:myapp/core/features/app_user/domain/usecases/submit_user_data_remotly.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';

part 'basic_information_event.dart';
part 'basic_information_state.dart';

class BasicInformationBloc
    extends Bloc<BasicInformationEvent, BasicInformationState> {
  final SubmitUserDataRemotly submitUserDataRemotly;
  BasicInformationBloc(this.submitUserDataRemotly)
      : super(BasicInformationInitial()) {
    on<UserDataSubmitted>((event, emit) async {
      emit(BasicInformationSubmitLoading());
      final response = await submitUserDataRemotly.call(SubmitUserDataParams(
          userId: event.userId,
          email: event.email,
          userName: event.userName,
          dob: event.dob,
          phoneNo: event.phoneNo,
          cnic: event.cnic,
          gender: event.gender,
          bloodGroup: event.bloodGroup,
          location: event.location,
          fcmToken: event.fcmToken,
          userProfileImageUrl: event.userProfileImageUrl));

      response.fold((l) => emit(BasicInformationSubmitFailure(l.message)),
          (r) => emit(BasicInformationSubmitSuccess()));
    });
  }
}
