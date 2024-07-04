import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/shimmer/blood_card_shimmer.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/presentation/bloc/blood_donation_bloc.dart';
import 'package:myapp/features/blood_donations/presentation/widgets/blood_donation_card.dart';
import 'package:myapp/features/blood_donations/presentation/widgets/blood_donation_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodDonationPage extends StatefulWidget {
  const BloodDonationPage({super.key});

  @override
  State<BloodDonationPage> createState() => _BloodDonationPageState();
}

class _BloodDonationPageState extends State<BloodDonationPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = false;
  User? _currentUser;

  List<Donation> donations = [];
  int radius = 4;
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    _currentUser = context.read<UserCubit>().state;

    fetchDonations();
    super.initState();
  }

  fetchDonations() {
    context.read<BloodDonationBloc>().add(
        BloodDonationInsideCertainRadiusFetched(LatitudeLongitude(
            latitude: _currentUser!.location.latitude,
            longitude: _currentUser!.location.longitude)));
  }

  void onChangedBloodGroups(List<String> updatedBloodGroups) {
    setState(() {
      bloodGroups = updatedBloodGroups;
    });
  }

  void onChangedRadius(int updatedRadius) {
    setState(() {
      radius = updatedRadius;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // _currentUser = context.watch<UserCubit>().state;

    return BlocConsumer<BloodDonationBloc, BloodDonationState>(
        listener: (context, state) {
      if (state is BloodDonationLoading) {
        _isLoading = true;
      }
      if (state is BloodDonationInsideCertainRadiusFailure) {
        _isLoading = false;

        showSnackBar(context, state.message);
      }
      if (state is BloodDonationInsideCertainRadiusSuccess) {
        _isLoading = false;

        donations = state.donations;
      }
    }, builder: (context, state) {
      List<Donation> filteredDonations = context
          .read<BloodDonationBloc>()
          .applyFilterOnDonations(
              donations: donations,
              bloodGroups: bloodGroups,
              radius: radius,
              currentUserPoints: LatitudeLongitude(
                  latitude: _currentUser!.location.latitude,
                  longitude: _currentUser!.location.longitude));

      return Scaffold(
        body: Column(
          children: [
            BloodDonationHeader(
                filteredDonations: filteredDonations,
                bloodGroups: bloodGroups,
                onChangedBloodGroups: onChangedBloodGroups,
                radius: radius,
                onChangedRadius: onChangedRadius),
            if (_isLoading)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemBuilder: (context, index) => const BloodCardShimmer(),
                  itemCount: 10,
                ),
              ),
            if (!_isLoading && filteredDonations.isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          kIsWeb
                              ? 'images/searching_did_not_find.png'
                              : 'assets/images/searching_did_not_find.png',
                          height: 200,
                          alignment: Alignment.center,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          AppLocalizations.of(context)!
                              .bloodDonationPage_NotFindDonation,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (!_isLoading && filteredDonations.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => await fetchDonations(),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemBuilder: (context, index) =>
                        BloodDonationCard(donation: filteredDonations[index]),
                    itemCount: filteredDonations.length,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
