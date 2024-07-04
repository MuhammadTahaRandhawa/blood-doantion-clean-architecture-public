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
import 'package:myapp/core/utilis/get_conversation_id.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/detail_form_field.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/core/widgets/rating_bar.dart';
import 'package:myapp/core/widgets/show_map_image_container.dart';
import 'package:myapp/features/blood_map/domain/entities/map_marker.dart';
import 'package:myapp/features/blood_map/presentation/pages/blood_maps_live_tracking_page.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/presentation/widgets/request_info.dart';
import 'package:myapp/features/chat/domain/entities/chat.dart';
import 'package:myapp/features/chat/presentation/pages/messages_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({super.key, required this.request});
  final Request request;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  Image? mapsImage;
  bool? isLoading;

  Rating? updatedRating;

  @override
  void initState() {
    super.initState();
    context.read<MapsBloc>().add(MapsStaticImageFetched(LatitudeLongitude(
        latitude: widget.request.location.latitude,
        longitude: widget.request.location.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;
    final requestRatings = context.watch<RatingCubit>().state;

    return Scaffold(
      body: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is PostAReportSuccess) {
            showSnackBar(context,
                AppLocalizations.of(context)!.bloodReqDetail_ReportSubmit);
          }
          if (state is PostAReportFailure) {
            showSnackBar(context,
                AppLocalizations.of(context)!.bloodReqDetail_submitError);
          }
        },
        child: PopScope(
          onPopInvoked: (didPop) {
            if (updatedRating != null) {
              context.read<RatingsBloc>().add(RatingOnRequestPosted(
                  widget.request.requestId, updatedRating!));
            }
          },
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.,
              children: [
                // Map or image container (LocationInputContainer)
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
                                  mapMarkerType: MapMarkerType.donation,
                                  icon: donorIcon,
                                  isActive: true,
                                  rating: 0),
                              destination: MapMarker(
                                  markerId: '2',
                                  userId: widget.request.userId,
                                  bloodGroup: '',
                                  userName: widget.request.requesterName,
                                  phoneNo: widget.request.phoneNo,
                                  fcmToken: null,
                                  location: widget.request.location,
                                  mapMarkerType: MapMarkerType.request,
                                  icon: requestIcon,
                                  isActive: true,
                                  rating: 0)),
                        ));
                      },
                      child: ShowMapImageContainer(
                        height: MediaQuery.of(context).size.height * 0.35,
                        mapsImage: mapsImage ??
                            const Center(child: CircularProgressIndicator()),
                        reportType: ReportType.request,
                        otherUserId: widget.request.userId,
                        reportTypeId: widget.request.requestId,
                      ),
                    )),
                // Wrap the following widgets with Padding for horizontal paddi , vertical: 16ng
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: RequestInfoWidget(
                    request: widget.request,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodReqDetail_name,
                    currentValue: widget.request.requesterName,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodReqDetail_bloodGroup,
                    currentValue: widget.request.bloodGroup,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodReqDetail_PhNo,
                    currentValue: widget.request.phoneNo,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodReqDetail_address,
                    currentValue: widget.request.location.address,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: DetailFormField(
                    labelText:
                        AppLocalizations.of(context)!.bloodReqDetail_hospital,
                    currentValue: widget.request.hospital ?? '',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: RatingWidget(
                    size: 25,
                    initialRating:
                        findInitialRating(requestRatings, currentUser),
                    onRatingUpdate: (value) {
                      onRatingUpdate(requestRatings, currentUser, value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: LargeGradientButton(
                    isDisabled: currentUser.userId == widget.request.userId,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MessagesPage(
                          chat: Chat(
                            chatId: getconversationIdHash(
                                currentUser.userId, widget.request.userId),
                            currentUserId: currentUser.userId,
                            otherUserId: widget.request.userId,
                            otherUserName: widget.request.requesterName,
                            currentUserName: currentUser.userName,
                            lastMessage: '',
                            currentUserImageUrl:
                                currentUser.userProfileImageUrl,
                            otherUserImageUrl: null,
                            lastMessageDateTime: DateTime.now(),
                            lastMessageSentBy: '',
                            currentUserFcmToken: currentUser.fcmToken,
                            otherUserFcmToken: null,
                          ),
                        ),
                      ));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.bloodReqDetail_help,
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
