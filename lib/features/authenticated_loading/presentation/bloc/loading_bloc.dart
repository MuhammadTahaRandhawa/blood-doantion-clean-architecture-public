import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/domain/usecases/fetch_user_data_remotly.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  final FetchUserDataRemotly fetchUserDataRemotly;
  LoadingBloc(this.fetchUserDataRemotly) : super(LoadingInitial()) {
    on<UserDataFetched>((event, emit) async {
      emit(UserFetchedLoading());
      final response = await fetchUserDataRemotly.call(unit);
      response.fold((l) => emit(UserFetchedFailure(l.message)),
          (r) => emit(UserFetchedSuccess(r)));
    });
  }
}
