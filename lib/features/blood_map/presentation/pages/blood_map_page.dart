import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/theme/app_pallete.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/blood_filter_bottom_sheet.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:myapp/features/blood_map/presentation/bloc/blood_map_bloc.dart';
import 'package:myapp/features/blood_map/presentation/widgets/custom_map_marker_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodMapPage extends StatefulWidget {
  const BloodMapPage({
    super.key,
  });

  @override
  State<BloodMapPage> createState() => _BloodMapPageState();
}

class _BloodMapPageState extends State<BloodMapPage> {
  Set<Marker> markers = {};
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  int radius = 4;
  List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;

    context.read<BloodMapBloc>().add(BloodMapAllMarkersAroundUserFetched(
        bloodGroups: bloodGroups,
        radius: radius,
        latitudeLongitude: LatitudeLongitude(
            latitude: currentUser.location.latitude,
            longitude: currentUser.location.longitude),
        currentUser: currentUser));

    return BlocConsumer<BloodMapBloc, BloodMapState>(
      listener: (context, state) {
        if (state is BloodMapMarkersFetchLoading) {
          if (kDebugMode) {
            print('loading blood markers');
          }
        }
        if (state is BloodMapRequestsMarkersFetchFailure) {
          showSnackBar(context, state.message);
        }
        if (state is BloodMapDonationsMarkersFetchFailure) {
          showSnackBar(context, state.message);
        }
        if (state is BloodMapCentersMarkersFetchFailure) {
          showSnackBar(context, state.message);
        }
        if (state is BloodMapAllMarkersFetchSuccess) {
          List<MapMarker> bloodMapMarkersData = state.markers;
          if (kDebugMode) {
            print(bloodMapMarkersData);
          }
          for (var markerData in bloodMapMarkersData) {
            markers.add(Marker(
                markerId: MarkerId(markerData.markerId),
                position: LatLng(markerData.location.latitude,
                    markerData.location.longitude),
                icon: markerData.icon,
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                      CustomMapMarkerInfo(mapMarker: markerData),
                      LatLng(markerData.location.latitude,
                          markerData.location.longitude));
                }));
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.bloodMapPage_appbar),
            actions: [
              BloodFilterIconBottomSheet(
                bloodGroups: bloodGroups,
                iconColor: Theme.of(context).colorScheme.primary,
                initialRadius: radius,
                onChangedBloodGroups: (selectedGroups) {
                  setState(() {
                    markers.clear();
                    bloodGroups = selectedGroups;
                  });
                },
                onChangedRadius: (newRadius) {
                  setState(() {
                    markers.clear();
                    radius = newRadius;
                  });
                },
              )
            ],
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(currentUser.location.latitude,
                        currentUser.location.longitude),
                    zoom: 16),
                myLocationEnabled: true,
                markers: markers,
                circles: {
                  Circle(
                      circleId: const CircleId(
                          'myCircle'), // Unique identifier for the circle
                      center: LatLng(
                          currentUser.location.latitude,
                          currentUser
                              .location.longitude), // Center of the circle
                      radius: radius *
                          1000.1, // Radius in meters (adjust as needed)
                      fillColor: AppPallete.primaryColor
                          .withOpacity(0.1), // Fill color for the circle
                      strokeColor: AppPallete.primaryColor.withOpacity(
                          0.5), // Stroke color for the circle border
                      strokeWidth: 1),
                },
                onMapCreated: (controller) {
                  _customInfoWindowController.googleMapController = controller;
                },
                onTap: (position) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 170,
                width: 300,
              )
            ],
          ),
        );
      },
    );
  }
}
