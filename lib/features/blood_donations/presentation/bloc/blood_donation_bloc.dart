import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/domain/usecases/fetch_donation_by_id.dart';
import 'package:myapp/features/blood_donations/domain/usecases/fetch_donation_inside_certain_radius.dart';
import 'package:myapp/features/blood_donations/domain/usecases/fetch_donations.dart';
import 'package:myapp/features/blood_donations/domain/usecases/fetch_my_donations.dart';
import 'package:myapp/features/blood_donations/domain/usecases/post_a_donation.dart';
import 'package:myapp/features/blood_donations/domain/usecases/streamof_donations_in_certain_radius.dart';
import 'package:myapp/features/blood_donations/domain/usecases/turn_off_donation.dart';

part 'blood_donation_event.dart';
part 'blood_donation_state.dart';

class BloodDonationBloc extends Bloc<BloodDonationEvent, BloodDonationState> {
  final FetchDonations fetchDonations;
  final PostADonation postADonation;
  final StreamOfDonationsInCertainRadius streamOfDonationsInCertainRadius;
  final FetchDonationsInsideCertainRadius fetchDonationsInsideCertainRadius;
  final FetchDonationById fetchDonationById;
  final FetchMyDonation fetchMyDonation;
  final TurnOffDonation turnOffDonation;
  BloodDonationBloc(
      this.fetchDonations,
      this.streamOfDonationsInCertainRadius,
      this.postADonation,
      this.fetchDonationsInsideCertainRadius,
      this.fetchDonationById,
      this.fetchMyDonation,
      this.turnOffDonation)
      : super(BloodDonationInitial()) {
    on<BloodDonationFetched>((event, emit) async {
      emit(BloodDonationLoading());
      final response = await fetchDonations.call(unit);

      response.fold((l) => emit(BloodDonationFetchedFailure(l.message)),
          (r) => emit(BloodDonationFetchedSuccess(r)));
    });

    on<BloodDonationStreamInsideARadiusFetched>((event, emit) {
      final response =
          streamOfDonationsInCertainRadius.call(event.latitudeLongitude);
      response.fold((l) => emit(BloodDonationStreamFailure(l.message)),
          (r) => emit(BloodDonationStreamSuccess(r)));
    });

    on<BloodDonationPosted>((event, emit) async {
      emit(BloodDonationPostLoading());
      final response = await postADonation.call(event.donation);
      response.fold((l) => emit(BloodDonationPostFailure(l.message)),
          (r) => emit(BloodDonationPostSuccess(r)));
    });

    on<BloodDonationInsideCertainRadiusFetched>((event, emit) async {
      emit(BloodDonationLoading());
      final response =
          await fetchDonationsInsideCertainRadius.call(event.latitudeLongitude);
      response.fold(
          (l) => emit(BloodDonationInsideCertainRadiusFailure(l.message)),
          (r) => emit(BloodDonationInsideCertainRadiusSuccess(r)));
    });

    on<BloodDonationByIdFetched>((event, emit) async {
      final res = await fetchDonationById.call(event.id);
      res.fold((l) => emit(BloodDonationByIdFetchedFailure(l.message)),
          (r) => emit(BloodDonationByIdFetchedSuccess(r)));
    });

    on<MyBloodDonationsFetched>((event, emit) async {
      final res = await fetchMyDonation.call(unit);
      res.fold((l) => emit(MyBloodDonationsFetchedFailure(l.message)),
          (r) => emit(MyBloodDonationsFetchedSuccess(r)));
    });

    on<BloodDonationTurnedOff>((event, emit) async {
      final res = await turnOffDonation.call(event.bloodDonation);
      res.fold((l) => emit(BloodDonationTurnedOffFailure(l.message)),
          (r) => emit(BloodDonationTurnedOffSuccess()));
    });
  }
  @override
  void onTransition(
      Transition<BloodDonationEvent, BloodDonationState> transition) {
    if (kDebugMode) {
      print(transition);
    }
    super.onTransition(transition);
  }

  List<Donation> applyFilterOnDonations(
      {required List<Donation> donations,
      required List<String> bloodGroups,
      required int radius,
      required LatitudeLongitude currentUserPoints}) {
    return donations.where((element) {
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

  Donation? isDonor(List<Donation> myDonations) {
    Donation? donation;
    for (var element in myDonations) {
      if (element.isActive == true) {
        donation = element;
      }
    }
    return donation;
  }
}
