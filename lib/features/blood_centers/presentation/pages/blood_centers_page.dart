import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';
import 'package:myapp/features/blood_centers/presentation/bloc/blood_center_bloc.dart';
import 'package:myapp/features/blood_centers/presentation/widgets/blood_center_card.dart';
import 'package:myapp/features/blood_centers/presentation/widgets/blood_center_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodCentersPage extends StatefulWidget {
  const BloodCentersPage({super.key});

  @override
  State<BloodCentersPage> createState() => _BloodCentersPageState();
}

class _BloodCentersPageState extends State<BloodCentersPage> {
  List<BloodCenter> bloodCenters = [];
  late final User currentUser;

  @override
  void initState() {
    currentUser = context.read<UserCubit>().state;
    context.read<BloodCenterBloc>().add(BloodCentersAroundUserFetched(
        LatitudeLongitude(
            latitude: currentUser.location.latitude,
            longitude: currentUser.location.longitude)));
    super.initState();
  }

  _fetchCenters() {
    context.read<BloodCenterBloc>().add(BloodCentersAroundUserFetched(
        LatitudeLongitude(
            latitude: currentUser.location.latitude,
            longitude: currentUser.location.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BloodCenterBloc, BloodCenterState>(
      listener: (context, state) {
        if (state is BloodCenterAroundUserFetchedFailure) {
          return showSnackBar(context, state.message);
        }
        if (state is BloodCenterAroundUserFetchedSuccess) {
          setState(() {
            bloodCenters = state.bloodCenters;
          });
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            BloodCenterHeader(bloodCenters: bloodCenters),
            if (bloodCenters.isEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => await _fetchCenters(),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                              textAlign: TextAlign.center,
                              AppLocalizations.of(context)!
                                  .bloodCenterPage_NotFindCenter),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (bloodCenters.isNotEmpty)
              Expanded(
                  child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) =>
                    BloodCenterCard(bloodCenter: bloodCenters[index]),
                itemCount: bloodCenters.length,
              )),
          ],
        ),
      ),
    );
  }
}
