import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
import 'package:myapp/core/utilis/get_conversation_id.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/detail_form_field.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/core/widgets/rating_bar.dart';
import 'package:myapp/core/widgets/show_map_image_container.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/presentation/widgets/donation_info_widget.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:myapp/features/blood_map/presentation/pages/blood_maps_live_tracking_page.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/presentation/pages/my_blood_requests_page.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/domain/entities/message.dart';
import 'package:myapp/features/chat/presentation/pages/messages_page.dart';

class DonationDetailPage extends StatefulWidget {
  const DonationDetailPage({super.key, required this.donation});
  final Donation donation;

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  Image? mapsImage;
  bool? isLoading;
  Rating? updatedRating;

  @override
  void initState() {
    super.initState();
    context.read<MapsBloc>().add(
          MapsStaticImageFetched(
            LatitudeLongitude(
              latitude: widget.donation.location.latitude,
              longitude: widget.donation.location.longitude,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;
    final donationRatings = context.watch<RatingCubit>().state;
    return Scaffold(
      body: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is PostAReportSuccess) {
            showSnackBar(context,
                AppLocalizations.of(context)!.bloodDonationDetail_reportSubmit);
          }
          if (state is PostAReportFailure) {
            showSnackBar(context,
                AppLocalizations.of(context)!.bloodDonationDetail_SubmitError);
          }
        },
        child: PopScope(
          onPopInvoked: (didPop) {
            if (updatedRating != null) {
              context.read<RatingsBloc>().add(
                    RatingOnDonationPosted(
                      widget.donation.donationId,
                      updatedRating!,
                    ),
                  );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Map or image container
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
                        final Uint8List requestIconBytes =
                            await getBytesFromAsset(
                                kIsWeb
                                    ? 'images/blood_request_marker.png'
                                    : 'assets/images/blood_request_marker.png',
                                300);
                        final requestIcon =
                            BitmapDescriptor.fromBytes(requestIconBytes);
                        final Uint8List donorIconBytes =
                            await getBytesFromAsset(
                                kIsWeb
                                    ? 'images/blood_donor_marker.png'
                                    : 'assets/images/blood_donor_marker.png',
                                300);
                        final donorIcon =
                            BitmapDescriptor.fromBytes(donorIconBytes);
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
                                  mapMarkerType: MapMarkerType.request,
                                  icon: requestIcon,
                                  isActive: true,
                                  rating: 0),
                              destination: MapMarker(
                                  markerId: '2',
                                  userId: widget.donation.userId,
                                  bloodGroup: '',
                                  userName: widget.donation.userName,
                                  phoneNo: widget.donation.phoneNo,
                                  fcmToken: null,
                                  location: widget.donation.location,
                                  mapMarkerType: MapMarkerType.donation,
                                  icon: donorIcon,
                                  isActive: true,
                                  rating: 0)),
                        ));
                      },
                      child: ShowMapImageContainer(
                          height: MediaQuery.of(context).size.height * 0.35,
                          mapsImage: mapsImage ??
                              const Center(child: CircularProgressIndicator()),
                          reportType: ReportType.donation,
                          otherUserId: widget.donation.userId,
                          reportTypeId: widget.donation.donationId),
                    )),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DonationInfoWidget(donation: widget.donation),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodDonationDetail_Name,
                    currentValue: widget.donation.userName,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DetailFormField(
                    labelText: AppLocalizations.of(context)!
                        .bloodDonationDetail_bloodGroup,
                    currentValue: widget.donation.bloodGroup,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodDonationDetail_PhNo,
                    currentValue: widget.donation.phoneNo,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DetailFormField(
                    labelText: AppLocalizations.of(context)!
                        .bloodDonationDetail_address,
                    currentValue: widget.donation.location.address,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RatingWidget(
                    size: 25,
                    initialRating:
                        findInitialRating(donationRatings, currentUser),
                    onRatingUpdate: (value) =>
                        onRatingUpdate(donationRatings, currentUser, value),
                  ),
                ),
                // Help button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: LargeGradientButton(
                    isDisabled: currentUser.userId == widget.donation.userId,
                    onPressed: () async {
                      final Request? res =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyBloodRequestsPage(
                          isSelecting: true,
                        ),
                      ));
                      if (res != null) {
                        gotoMessagePage(context, res, currentUser);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.bloodDonationDetail_askHelp,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
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
      ratingType: RatingType.request,
      userName: currentUser.userName,
      userId: currentUser.userId,
      rating: rating,
      timestamp: DateTime.now(),
      userProfileImageUrl: currentUser.userProfileImageUrl,
    );
    if (userRatings.isEmpty) {
      context.read<RatingCubit>().addRating(updatedRating!);
    } else {
      context
          .read<RatingCubit>()
          .updateRating(userRatings.first, updatedRating!);
    }
  }

  void gotoMessagePage(
      BuildContext context, Request request, User currentUser) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MessagesPage(
          messageTypeId: request.userId,
          defaultMessage: MessageType.request,
          chat: Chat(
              chatId: getconversationIdHash(
                  currentUser.userId, widget.donation.userId),
              currentUserId: currentUser.userId,
              otherUserId: widget.donation.userId,
              otherUserName: widget.donation.userName,
              currentUserName: currentUser.userName,
              lastMessage: '',
              currentUserImageUrl: currentUser.userProfileImageUrl,
              otherUserImageUrl: widget.donation.userProfileImageUrl,
              lastMessageDateTime: DateTime.now(),
              lastMessageSentBy: currentUser.userId,
              currentUserFcmToken: currentUser.fcmToken,
              otherUserFcmToken: widget.donation.fcmToken)),
    ));
  }
}
