import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/utilis/get_bytes_from_assets.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/blood_centers/presentation/bloc/blood_center_bloc.dart';
import 'package:myapp/features/blood_centers/presentation/pages/blood_center_detail_page.dart';
import 'package:myapp/features/blood_donations/presentation/bloc/blood_donation_bloc.dart';
import 'package:myapp/features/blood_donations/presentation/pages/blood_donation_detail_page.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:myapp/features/blood_map/presentation/pages/blood_maps_live_tracking_page.dart';
import 'package:myapp/features/blood_requests/presentation/bloc/blood_request_bloc.dart';
import 'package:myapp/features/blood_requests/presentation/pages/blood_request_detail_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomMapMarkerInfo extends StatelessWidget {
  const CustomMapMarkerInfo({super.key, required this.mapMarker});

  final MapMarker mapMarker;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    return MultiBlocListener(
      listeners: [
        BlocListener<BloodDonationBloc, BloodDonationState>(
          listener: (context, state) {
            if (state is BloodDonationByIdFetchedFailure) {
              return showSnackBar(context, state.message);
            }
            if (state is BloodDonationByIdFetchedSuccess) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    DonationDetailPage(donation: state.donation),
              ));
            }
          },
        ),
        BlocListener<BloodRequestBloc, BloodRequestState>(
          listener: (context, state) {
            if (state is BloodRequestByIdFetchedFailure) {
              return showSnackBar(context, state.message);
            }
            if (state is BloodRequestByIdFetchedSuccess) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequestDetailPage(request: state.request),
              ));
            }
          },
        ),
        BlocListener<BloodCenterBloc, BloodCenterState>(
          listener: (context, state) {
            if (state is BloodCenterByIdFetchedFailure) {
              return showSnackBar(context, state.message);
            }
            if (state is BloodCenterByIdFetchedSuccess) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BloodCenterDetailPage(
                  bloodCenter: state.center,
                ),
              ));
            }
          },
        ),
      ],
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(mapMarker.userName,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                  ),
                  if (mapMarker.mapMarkerType != MapMarkerType.center)
                    Expanded(
                        flex: 1,
                        child: CircleAvatar(
                            child: Text(
                          mapMarker.bloodGroup!,
                        ))),
                ],
              ),
              const Spacer(),
              Text(
                mapMarker.location.address,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () async {
                        final Uint8List userIconBytes = await getBytesFromAsset(
                            kIsWeb
                                ? 'images/user_marker.png'
                                : 'assets/images/user_marker.png',
                            100);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BloodMapLiveTrackingPage(
                            source: MapMarker(
                                isActive: true,
                                rating: 0,
                                markerId: user.userId,
                                userId: user.userId,
                                bloodGroup: user.bloodGroup,
                                userName: user.userName,
                                phoneNo: user.phoneNo,
                                fcmToken: user.fcmToken,
                                location: user.location,
                                mapMarkerType: MapMarkerType.donation,
                                icon:
                                    BitmapDescriptor.fromBytes(userIconBytes)),
                            destination: mapMarker,
                          ),
                        ));
                      },
                      child: Text(
                          AppLocalizations.of(context)!.customMap_findRoute)),
                  FilledButton(
                      onPressed: () {
                        if (mapMarker.mapMarkerType == MapMarkerType.center) {
                          context
                              .read<BloodCenterBloc>()
                              .add(BloodCenterByIdFetched(mapMarker.markerId));
                        } else if (mapMarker.mapMarkerType ==
                            MapMarkerType.donation) {
                          context.read<BloodDonationBloc>().add(
                              BloodDonationByIdFetched(mapMarker.markerId));
                        } else if (mapMarker.mapMarkerType ==
                            MapMarkerType.request) {
                          context
                              .read<BloodRequestBloc>()
                              .add(BloodRequestByIdFetched(mapMarker.markerId));
                        }
                      },
                      child: Text(
                          AppLocalizations.of(context)!.customMap_viewDetail)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
