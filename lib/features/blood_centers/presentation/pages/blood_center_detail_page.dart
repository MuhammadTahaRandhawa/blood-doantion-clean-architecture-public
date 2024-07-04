import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:myapp/core/features/rating/domain/entities/rating.dart';
import 'package:myapp/core/features/rating/presentation/bloc/ratings_bloc.dart';
import 'package:myapp/core/features/rating/presentation/cubit/rating_cubit.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/presentation/bloc/report_bloc.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/get_bytes_from_assets.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/detail_form_field.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/core/widgets/rating_bar.dart';
import 'package:myapp/core/widgets/show_map_image_container.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';
import 'package:myapp/features/blood_centers/presentation/pages/blood_center_appointment_page.dart';
import 'package:myapp/features/blood_centers/presentation/widgets/blood_center_detail_info_window.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:myapp/features/blood_map/presentation/pages/blood_maps_live_tracking_page.dart';

class BloodCenterDetailPage extends StatefulWidget {
  const BloodCenterDetailPage({super.key, required this.bloodCenter});
  final BloodCenter bloodCenter;

  @override
  State<BloodCenterDetailPage> createState() => _BloodCenterDetailPageState();
}

class _BloodCenterDetailPageState extends State<BloodCenterDetailPage> {
  Image? mapsImage;
  bool? isLoading;

  Rating? updatedRating;

  @override
  void initState() {
    super.initState();
    context.read<MapsBloc>().add(MapsStaticImageFetched(LatitudeLongitude(
        latitude: widget.bloodCenter.centerLocation.latitude,
        longitude: widget.bloodCenter.centerLocation.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;
    final centerRatings = context.watch<RatingCubit>().state;

    return Scaffold(
      body: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is PostAReportSuccess) {
            showSnackBar(context,
                AppLocalizations.of(context)!.bloodCenterdetail_reportSubmit);
          }
          if (state is PostAReportFailure) {
            showSnackBar(context,
                AppLocalizations.of(context)!.bloodCenterdetail_SubmitError);
          }
        },
        child: PopScope(
          onPopInvoked: (didPop) {
            if (updatedRating != null) {
              context.read<RatingsBloc>().add(RatingOnRequestPosted(
                  widget.bloodCenter.centerId, updatedRating!));
            }
          },
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.,
              children: [
                BlocListener<MapsBloc, MapsState>(
                    listener: (context, state) {
                      if (state is MapsStaticImageSuccess) {
                        setState(() {
                          mapsImage = state.image;
                        });
                      }
                    },
                    child: GestureDetector(
                      onTap: () async {
                        final Uint8List donorIconBytes =
                            await getBytesFromAsset(
                                kIsWeb
                                    ? 'images/blood_donor_marker.png'
                                    : 'assets/images/blood_donor_marker.png',
                                300);
                        final donorIcon =
                            BitmapDescriptor.fromBytes(donorIconBytes);
                        final Uint8List centerIconBytes =
                            await getBytesFromAsset(
                                kIsWeb
                                    ? 'images/hospital_marker.png'
                                    : 'assets/images/hospital_marker.png',
                                300);
                        final centerIcon =
                            BitmapDescriptor.fromBytes(centerIconBytes);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BloodMapLiveTrackingPage(
                              source: MapMarker(
                                  markerId: '1',
                                  userId: currentUser.userId,
                                  bloodGroup: currentUser.userId,
                                  userName: currentUser.userName,
                                  phoneNo: currentUser.phoneNo,
                                  fcmToken: currentUser.fcmToken,
                                  location: currentUser.location,
                                  mapMarkerType: MapMarkerType.donation,
                                  icon: donorIcon,
                                  isActive: true,
                                  rating: 0),
                              destination: MapMarker(
                                  markerId: '2',
                                  userId: widget.bloodCenter.centerId,
                                  bloodGroup: '',
                                  userName: widget.bloodCenter.centerName,
                                  phoneNo: widget.bloodCenter.centerPhoneNo,
                                  fcmToken: null,
                                  location: widget.bloodCenter.centerLocation,
                                  mapMarkerType: MapMarkerType.center,
                                  icon: centerIcon,
                                  isActive: true,
                                  rating: 0)),
                        ));
                      },
                      child: ShowMapImageContainer(
                          height: MediaQuery.of(context).size.height * 0.4,
                          mapsImage: mapsImage ??
                              const Center(child: CircularProgressIndicator()),
                          reportType: ReportType.centre,
                          otherUserId: widget.bloodCenter.centerId,
                          reportTypeId: widget.bloodCenter.centerId),
                    )),
                // Wrap the following widgets with Padding for horizontal paddi , vertical: 16ng
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    child: BloodCenterDetailInfoWindow(
                        bloodCenter: widget.bloodCenter)),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodCenterdetail_Name,
                    currentValue: widget.bloodCenter.centerName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodCenterdetail_PhNo,
                    currentValue: widget.bloodCenter.centerPhoneNo,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodCenterdetail_Address,
                    currentValue: widget.bloodCenter.centerLocation.address,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: RatingWidget(
                    size: 25,
                    initialRating:
                        findInitialRating(centerRatings, currentUser),
                    onRatingUpdate: (value) {
                      onRatingUpdate(centerRatings, currentUser, value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: LargeGradientButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BloodCenterScheduleAppointmentPage(
                          bloodCenter: widget.bloodCenter,
                        ),
                      ));
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .bloodCenterdetail_ScheduleAppointment,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double findInitialRating(List<Rating> ratings, User currentUser) {
    final userRatings =
        ratings.where((rating) => rating.userId == currentUser.userId).toList();
    if (userRatings.isEmpty) {
      return 0;
    } else {
      return userRatings.first.rating;
    }
  }

  void onRatingUpdate(List<Rating> ratings, User currentUser, double rating) {
    final userRatings =
        ratings.where((rating) => rating.userId == currentUser.userId).toList();
    updatedRating = Rating(
        ratingId: userRatings.isNotEmpty ? userRatings.first.ratingId : null,
        ratingType: RatingType.centre,
        userName: currentUser.userName,
        userId: currentUser.userId,
        rating: rating,
        timestamp: DateTime.now(),
        userProfileImageUrl: currentUser.userProfileImageUrl);
    if (userRatings.isEmpty) {
      context.read<RatingCubit>().addRating(updatedRating!);
    } else {
      context
          .read<RatingCubit>()
          .updateRating(userRatings.first, updatedRating!);
    }
  }
}
