import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/bloc/appointment_bloc.dart';
import 'package:myapp/core/features/location/domain/entities/location.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/utilis/user_basic_infromation_validator.dart';
import 'package:myapp/core/widgets/custom_drop_down_form_field.dart';
import 'package:myapp/core/widgets/custom_text_form_field.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/core/widgets/select_blood_group.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';

class BloodCenterScheduleAppointmentPage extends StatefulWidget {
  const BloodCenterScheduleAppointmentPage(
      {super.key, required this.bloodCenter});

  final BloodCenter bloodCenter;

  @override
  State<BloodCenterScheduleAppointmentPage> createState() =>
      _BloodCenterScheduleAppointmentPageState();
}

class _BloodCenterScheduleAppointmentPageState
    extends State<BloodCenterScheduleAppointmentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late User currentUser;
  bool _autofill = false;
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bloodBagController = TextEditingController();
  // BloodCenterAppointment? appointment;
  String? _initialBloodGroup;
  String bloodGroup = '';
  Location? requestLocation;
  LatLng? latLng;
  UserInformationValidator userInformationValidator =
      UserInformationValidator();
  AppointmentType appointmentType = AppointmentType.values.first;
  AppointmentCase appointmentCase = AppointmentCase.values.first;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bloodCenterApoint_appbar),
        actions: [
          Switch(
            value: _autofill,
            onChanged: toggleSwitch,
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
                  hintText:
                      AppLocalizations.of(context)!.bloodCenterApoint_fullName,
                  validator: userInformationValidator.userNameValidator,
                  icon: const Icon(Icons.person),
                  controller: _fullNameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  icon: const Icon(Icons.phone),
                  hintText:
                      AppLocalizations.of(context)!.bloodCenterApoint_PhNo,
                  validator: userInformationValidator.phoneNoValidator,
                  controller: _phoneController,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomDropDownFormField(
                  data: AppointmentType.values,
                  onChanged: onChangedAppointmentType,
                  icon: const Icon(Icons.radio_button_checked),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (appointmentType == AppointmentType.request)
                  CustomTextFormField(
                    controller: _bloodBagController,
                    hintText: AppLocalizations.of(context)!
                        .bloodCenterApoint_BloodBags,
                    icon: const Icon(Icons.bloodtype),
                    validator:
                        userInformationValidator.validateBloodBagsQuantity,
                  ),
                if (appointmentType == AppointmentType.request)
                  const SizedBox(
                    height: 20,
                  ),
                if (appointmentType == AppointmentType.request)
                  CustomDropDownFormField(
                    data: AppointmentCase.values
                        .map((e) => Appointment.getAppointmentCaseAsString(e))
                        .toList(),
                    icon: const Icon(Icons.warning),
                    hintText:
                        AppLocalizations.of(context)!.bloodCenterApoint_case,
                    onChanged: onChangedAppointmentCase,
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
                const SizedBox(
                  height: 30,
                ),
                LargeGradientButton(
                  onPressed: onPressedSubmitButton,
                  child: Text(
                    AppLocalizations.of(context)!.bloodCenterApoint_SubmitBtn,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleSwitch(bool value) {
    _initialBloodGroup = _autofill ? currentUser.bloodGroup : null;
    setState(() {
      _autofill = value;
      _fullNameController.text = _autofill == true ? currentUser.userName : '';
      _phoneController.text = _autofill == true ? currentUser.phoneNo : '';
    });
  }

  void onChangedAppointmentType(value) {
    if (value != null) {
      setState(() {
        appointmentType = value;
      });
    }
  }

  void onChangedAppointmentCase(value) {
    if (value != null) {
      setState(() {
        appointmentCase = Appointment.getAppointmentCaseFromString(value);
      });
    }
  }

  void onPressedSubmitButton() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    userInformationValidator
        .validateBloodGroup(bloodGroup)
        .fold((l) => showSnackBar(context, l), (r) => null);
    if (userInformationValidator.validateBloodGroup(bloodGroup).isLeft()) {
      return;
    }

    final appointment = Appointment(
      participantIsCompleted: null,
      createrIsCompleted: null,
      appointmentStatus: AppointmentStatus.pending,
      appointmentType: appointmentType,
      bloodGroup: bloodGroup,
      appointmentParticipantId: widget.bloodCenter.centerId,
      appointmentCreaterId: currentUser.userId,
      appointmentLocation: widget.bloodCenter.centerLocation,
      appointmentCreaterPhoneNo: currentUser.phoneNo,
      appointmentOtherPartyType: AppointmentOtherParty.center,
      appointmentDateTime: null,
      appointmentDateTimeCreated: DateTime.now(),
      appointmentParticipantName: widget.bloodCenter.centerName,
      appointmentCreaterName: currentUser.userName,
      appointmentCase:
          appointmentType == AppointmentType.donation ? null : appointmentCase,
      bloodBags: _bloodBagController.text == ''
          ? null
          : int.parse(_bloodBagController.text),
    );
    context.read<AppointmentBloc>().add(AppointmentSubmitted(appointment));
    Navigator.pop(context);
  }
}
