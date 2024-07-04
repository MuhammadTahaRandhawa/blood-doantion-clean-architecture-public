import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';

class BloodRequestCubit extends Cubit<List<Request>> {
  BloodRequestCubit() : super([]);

  void initializeBloodRequests(List<Request> requets) {
    emit(requets);
  }

  void addNewRequest(Request request) {
    emit([...state, request]);
  }

  List<Request> applyFilter(
      {required List<Request> requests,
      required List<String> bloodGroups,
      required int radius,
      required LatitudeLongitude currentUserPoints}) {
    return requests.where((element) {
      final distance = (Geolocator.distanceBetween(
          currentUserPoints.latitude,
          currentUserPoints.longitude,
          element.location.latitude,
          element.location.longitude));

      if (radius * 1000 > distance &&
          bloodGroups.contains(element.bloodGroup)) {
        return true;
      }
      return false;
    }).toList();
  }
}
