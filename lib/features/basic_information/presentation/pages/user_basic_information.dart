import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/bloc/user_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/pages/bottom_navigation_bar.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/features/location/presentation/bloc/location_bloc.dart';
import 'package:myapp/core/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:myapp/core/utilis/date_formatter.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/utilis/user_basic_infromation_validator.dart';
import 'package:myapp/core/widgets/custom_text_form_field.dart';
import 'package:myapp/core/widgets/date_picker_form_field.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/core/widgets/select_blood_group.dart';
import 'package:myapp/core/widgets/select_gender.dart';
import 'package:myapp/features/blood_donations/presentation/pages/donation_guidelines_page.dart';
import 'package:myapp/init_dependencies.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BasicInformationPage extends StatefulWidget {
  const BasicInformationPage({super.key});

  @override
  State<BasicInformationPage> createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late User user;
  bool becomeADonor = false;

  final _userNameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _phoneController = TextEditingController();
  final UserInformationValidator userBasicInformationValidator =
      UserInformationValidator();

  String? _gender;
  String? _bloodGroup;
  DateTime? _dob;
  late final Location location;

  @override
  void initState() {
    context.read<UserBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.basicInfo_Appbar),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSubmittedLoading) {
            setState(() {
              _isLoading = true;
            });
          }
          if (state is UserSubmittedFailure) {
            setState(() {
              _isLoading = false;
            });

            return showSnackBar(context, state.message);
          }
          if (state is UserSubmittedSuccess) {
            context.read<UserCubit>().initializeUser(user);
            if (becomeADonor) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const DonationGuidelinesPage(),
                  ),
                  (route) => false);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const AppBottomNavigation(),
                  ),
                  (route) => false);
            }
          }
        },
        builder: (context, state) {
          return BlocConsumer<LocationBloc, LocationState>(
            listener: (locationContext, locationState) {
              if (locationState is LocationLoading) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (locationState is LocationFailure) {
                showSnackBar(context, locationState.message);
                setState(() {
                  _isLoading = false;
                });
              }
              if (locationState is LocationSuccess) {
                setState(() {
                  _isLoading = false;
                });
                location = locationState.successData;
                context
                    .read<NotificationBloc>()
                    .add(NotificationsPermissionRequested());
              }
            },
            builder: (locationContext, state) {
              return BlocListener<NotificationBloc, NotificationState>(
                listener: (context, state) {
                  if (state is NotificationPermissionSuccess) {
                    context
                        .read<NotificationBloc>()
                        .add(NotificationDeviceFcmTokenRequested());
                  }
                  if (state is GetFcmTokenSuccess) {
                    user = User(
                        userId: serviceLocator<FirebaseAuth>().currentUser!.uid,
                        email:
                            serviceLocator<FirebaseAuth>().currentUser!.email!,
                        userName: _userNameController.text,
                        dob: _dob!,
                        phoneNo: _phoneController.text,
                        cnic: _cnicController.text,
                        gender: _gender!,
                        bloodGroup: _bloodGroup!,
                        location: location,
                        fcmToken: state.fcmToken);
                    context
                        .read<UserBloc>()
                        .add(UserDataSubmittedRemotly(user: user));
                  }
                  if (state is NotificationPermissionFailure ||
                      state is GetFcmTokenFailure) {
                    user = User(
                        userId: serviceLocator<FirebaseAuth>().currentUser!.uid,
                        email:
                            serviceLocator<FirebaseAuth>().currentUser!.email!,
                        userName: _userNameController.text,
                        dob: _dob!,
                        phoneNo: _phoneController.text,
                        cnic: _cnicController.text,
                        gender: _gender!,
                        bloodGroup: _bloodGroup!,
                        location: location);
                    context
                        .read<UserBloc>()
                        .add(UserDataSubmittedRemotly(user: user));
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextFormField(
                                    hintText: AppLocalizations.of(context)!
                                        .basicInfo_fullName,
                                    obsecureText: false,
                                    icon: const Icon(Icons.person),
                                    controller: _userNameController,
                                    validator: userBasicInformationValidator
                                        .userNameValidator),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextFormField(
                                  hintText: AppLocalizations.of(context)!
                                      .basicInfo_CNIC,
                                  icon: const Icon(Icons.credit_card),
                                  obsecureText: false,
                                  controller: _cnicController,
                                  validator: userBasicInformationValidator
                                      .cnicValidator,
                                  keyBoardType: TextInputType.number,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextFormField(
                                    hintText: AppLocalizations.of(context)!
                                        .basicInfo_PhNum,
                                    icon: const Icon(Icons.phone),
                                    controller: _phoneController,
                                    keyBoardType: TextInputType.phone,
                                    validator: userBasicInformationValidator
                                        .phoneNoValidator),
                                const SizedBox(
                                  height: 20,
                                ),
                                DatePickerFormfield(
                                  text: AppLocalizations.of(context)!
                                      .basicInfo_DOB,
                                  validator:
                                      userBasicInformationValidator.validateDOB,
                                  onSaved: (value) {
                                    _dob = DateFormatter.stringToDate(value!);
                                    if (DateFormatter.dobCanDonate(_dob!)) {
                                      setState(() {
                                        becomeADonor = true;
                                      });
                                    } else {
                                      setState(() {
                                        becomeADonor = false;
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(AppLocalizations.of(context)!
                                    .basicInfo_Gender),
                                const SizedBox(
                                  height: 5,
                                ),
                                SelectGender(
                                  onChanged: (p0) {
                                    _gender = p0 ? 'male' : 'female';
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(AppLocalizations.of(context)!
                                    .basicInfo_chooseBlood),
                                const SizedBox(
                                  height: 5,
                                ),
                                SelectBloodGroup(
                                  onChanged: (p0) {
                                    _bloodGroup = p0;
                                  },
                                ),
                                CheckboxListTile.adaptive(
                                    value: becomeADonor,
                                    title: Text(AppLocalizations.of(context)!
                                        .basicInfo_BecomeDonor),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          becomeADonor = value;
                                        });
                                      }
                                    }),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_isLoading)
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: LargeGradientButton(
                              onPressed: () {
                                return;
                              },
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                        if (!_isLoading)
                          Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: LargeGradientButton(
                                  isDisabled: _isLoading,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .basicInfo_submitBtn,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();

                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final nonFormFieldValidation =
                                        userBasicInformationValidator
                                            .validateNonFormFieldValues(
                                                _bloodGroup, _gender);
                                    nonFormFieldValidation.fold(
                                      (l) {
                                        showSnackBar(context, l);
                                        return;
                                      },
                                      (r) {} //do nothing on right
                                      ,
                                    );
                                    if (nonFormFieldValidation.isLeft()) {
                                      return;
                                    }
                                    _formKey.currentState!.save();
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    locationContext
                                        .read<LocationBloc>()
                                        .add(LocationFetched());
                                  })),
                      ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
