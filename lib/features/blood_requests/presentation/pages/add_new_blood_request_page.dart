import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/features/location/presentation/bloc/location_bloc.dart';
import 'package:myapp/core/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/utilis/user_basic_infromation_validator.dart';
import 'package:myapp/core/widgets/custom_drop_down_form_field.dart';
import 'package:myapp/core/widgets/custom_text_form_field.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/core/widgets/select_blood_group.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:myapp/features/blood_requests/presentation/bloc/blood_request_bloc.dart';
import 'package:myapp/features/blood_requests/presentation/cubit/blood_request_cubit.dart';
import 'package:myapp/features/blood_requests/presentation/pages/select_request_location_on_map.dart';
import 'package:myapp/features/blood_requests/presentation/widgets/maximum_limit_check.dart';
import 'package:myapp/features/blood_requests/presentation/widgets/request_location_map_image_input_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewBloodRequestPage extends StatefulWidget {
  const AddNewBloodRequestPage({super.key});

  @override
  State<AddNewBloodRequestPage> createState() => _AddNewBloodRequestPageState();
}

class _AddNewBloodRequestPageState extends State<AddNewBloodRequestPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User currentUser;
  Image? _mapsImage;
  bool _isLoadingImage = false;
  bool _autofill = false;
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _bloodBagController = TextEditingController();
  Request? request;
  String? _initialBloodGroup;
  String bloodGroup = '';
  Location? requestLocation;
  List<Request> userRequestsToday = [];
  LatLng? latLng;
  UserInformationValidator userInformationValidator =
      UserInformationValidator();
  AppointmentCase requestCase = AppointmentCase.values.first;

  @override
  void initState() {
    context.read<BloodRequestBloc>().add(BloodRequestsFetched());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _hospitalController.dispose();
    _bloodBagController.dispose();
  }

  Widget loadingWidget = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    currentUser = context.watch<UserCubit>().state;
    //This Bloc Builder is to verify that user can only put 2 requests per day.
    return BlocBuilder<BloodRequestBloc, BloodRequestState>(
      builder: (context, state) {
        if (state is BloodRequestsFetchFailure) {
          showSnackBar(context, state.message);
          return Center(child: Text(state.message));

          // return Navigator.pop(context);
        }
        // if (state is BloodRequestFetchLoading) {
        //   return loadingWidget;
        // }
        if (state is BloodRequestsFetchSuccess) {
          final requests = state.requests
              .where(
                (element) => (element.userId == currentUser.userId &&
                    element.requestDateTime.day == DateTime.now().day &&
                    element.isActive),
              )
              .toList();
          userRequestsToday = requests;

          return BlocConsumer<MapsBloc, MapsState>(
            listener: (context, state) {
              if (state is MapsStaticImageSuccess) {
                _mapsImage = state.image;
                setState(() {
                  _isLoadingImage = false;
                });
              }
            },
            builder: (context, state) {
              checkMaxiumLimit(context, userRequestsToday);
              return PopScope(
                onPopInvoked: (didPop) {
                  // context.read<BloodRequestBloc>().add(
                  //     BloodRequestInsideARadiusFetched(LatitudeLongitude(
                  //         latitude: currentUser.location.latitude,
                  //         longitude: currentUser.location.longitude)));
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context)!.addNewReq_appBar),
                    actions: [
                      Switch(
                        value: _autofill,
                        onChanged: (value) {
                          _initialBloodGroup =
                              _autofill ? currentUser.bloodGroup : null;
                          setState(() {
                            _autofill = value;
                            _fullNameController.text =
                                _autofill == true ? currentUser.userName : '';
                            _phoneController.text =
                                _autofill == true ? currentUser.phoneNo : '';
                          });
                        },
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              hintText: AppLocalizations.of(context)!
                                  .addNewReq_fullName,
                              validator:
                                  userInformationValidator.userNameValidator,
                              icon: const Icon(Icons.person),
                              controller: _fullNameController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              icon: const Icon(Icons.phone),
                              hintText:
                                  AppLocalizations.of(context)!.addNewReq_PhNo,
                              //initalValue: _autofill == true ? _currentUser.phoneNo : null,
                              validator:
                                  userInformationValidator.phoneNoValidator,
                              controller: _phoneController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              controller: _bloodBagController,
                              hintText: AppLocalizations.of(context)!
                                  .addNewReq_bloodBag,
                              icon: const Icon(Icons.bloodtype),
                              validator: userInformationValidator
                                  .validateBloodBagsQuantity,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomDropDownFormField(
                              data: AppointmentCase.values,
                              icon: const Icon(Icons.warning),
                              hintText: 'Case',
                              onChanged: onChangedAppointmentCase,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              controller: _hospitalController,
                              hintText: AppLocalizations.of(context)!
                                  .addNewReq_hospital,
                              icon: const Icon(Icons.local_hospital),
                              validator: (value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SelectBloodGroup(
                              onChanged: (value) {
                                bloodGroup = value;
                              },
                              initialValue: _initialBloodGroup,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            BlocListener<LocationBloc, LocationState>(
                              listener: (context, state) {
                                if (state is LocationSuccess) {
                                  final address = state.successData;
                                  requestLocation = Location(
                                      latitude: latLng!.latitude,
                                      longitude: latLng!.longitude,
                                      address: address);
                                }
                              },
                              child: RequestLocationMapImageInputContainer(
                                mapsImage: _isLoadingImage
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : _mapsImage,
                                onPressedChooseCurrentLocation:
                                    onChooseCurrentLocation,
                                onPressedChooseLocationOnMap:
                                    onChooseLocationOnMap,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            BlocConsumer<BloodRequestBloc, BloodRequestState>(
                              listener: (context, state) {
                                if (state is BloodRequestPostLoading) {}
                                if (state is BloodRequestPostFailure) {
                                  showSnackBar(context, state.message);
                                }
                              },
                              builder: (context, state) {
                                return LargeGradientButton(
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    userInformationValidator
                                        .validateBloodGroup(bloodGroup)
                                        .fold((l) => showSnackBar(context, l),
                                            (r) => null);
                                    if (userInformationValidator
                                        .validateBloodGroup(bloodGroup)
                                        .isLeft()) {
                                      return;
                                    }
                                    if (requestLocation == null) {
                                      return showSnackBar(
                                          context,
                                          AppLocalizations.of(context)!
                                              .addNewReq_chooseLocation);
                                    }

                                    request = Request(
                                        userId: currentUser.userId,
                                        requesterName: _fullNameController.text,
                                        phoneNo: _phoneController.text,
                                        hospital: _hospitalController.text,
                                        location: requestLocation!,
                                        requestDateTime: DateTime.now(),
                                        bloodGroup: bloodGroup,
                                        bloodBags:
                                            int.parse(_bloodBagController.text),
                                        fcmToken: currentUser.fcmToken,
                                        isActive: true,
                                        rating: 0,
                                        userProfileImageUrl:
                                            currentUser.userProfileImageUrl,
                                        requestCase: requestCase);
                                    context.read<BloodRequestBloc>().add(
                                        BloodRequestPosted(request: request!));
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .addNewReq_submitBtn,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        if (state is BloodRequestPostSuccess) {
          context.read<BloodRequestCubit>().addNewRequest(request!);
          log('success');
          Navigator.pop(
            context,
          );
        }
        return loadingWidget;
      },
    );
  }

  void onChangedAppointmentCase(value) {
    if (value != null) {
      setState(() {
        requestCase = value;
      });
    }
  }

  fetchMapsStaticImage(LatLng location) {
    context.read<MapsBloc>().add(MapsStaticImageFetched(LatitudeLongitude(
        latitude: location.latitude, longitude: location.longitude)));
    setState(() {
      _isLoadingImage = true;
    });
  }

  onChooseCurrentLocation() {
    latLng =
        LatLng(currentUser.location.latitude, currentUser.location.longitude);
    final address = currentUser.location.address;
    requestLocation = Location(
        latitude: latLng!.latitude,
        longitude: latLng!.longitude,
        address: address);
    fetchMapsStaticImage(latLng!);
  }

  onChooseLocationOnMap() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SelectRequestLocationOnMapPage(
        location: currentUser.location,
        getLatLong: (p0) {
          latLng = p0;
        },
      ),
    ));
    if (latLng == null) {
      return;
    }
    fetchMapsStaticImage(latLng!);
    context.read<LocationBloc>().add(LocationAddressFetched(LatitudeLongitude(
        latitude: latLng!.latitude, longitude: latLng!.longitude)));
  }
}
