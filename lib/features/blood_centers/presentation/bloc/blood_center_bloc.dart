import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';
import 'package:myapp/features/blood_centers/domain/usecases/fetch_blood_centers_around_user.dart';
import 'package:myapp/features/blood_centers/domain/usecases/fetch_center_by_id.dart';

part 'blood_center_event.dart';
part 'blood_center_state.dart';

class BloodCenterBloc extends Bloc<BloodCenterEvent, BloodCenterState> {
  final FetchBloodCentersAroundUser fetchBloodCentersAroundUser;
  final FetchCenterById fetchCenterById;
  BloodCenterBloc(this.fetchBloodCentersAroundUser, this.fetchCenterById)
      : super(BloodCenterInitial()) {
    on((event, emit) => BloodCenterLoading());
    on<BloodCentersAroundUserFetched>((event, emit) async {
      final res =
          await fetchBloodCentersAroundUser.call(event.latitudeLongitude);
      res.fold((l) => emit(BloodCenterAroundUserFetchedFailure(l.message)),
          (r) => emit(BloodCenterAroundUserFetchedSuccess(r)));
    });
    on<BloodCenterByIdFetched>((event, emit) async {
      final res = await fetchCenterById.call(event.id);
      res.fold((l) => emit(BloodCenterByIdFetchedFailure(l.message)),
          (r) => emit(BloodCenterByIdFetchedSuccess(r)));
    });
  }
}
