import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/bloc/user_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/utilis/date_formatter.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/utilis/text_formatter.dart';
import 'package:myapp/core/utilis/user_basic_infromation_validator.dart';
import 'package:myapp/core/widgets/date_picker_form_field.dart';
import 'package:myapp/core/widgets/select_blood_group.dart';
import 'package:myapp/core/widgets/select_gender.dart';
import 'package:myapp/features/profile/presentation/widgets/profile_form_field.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    super.key,
  });

  // final UserModel user;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  Image? image;
  File? file;
  String? imageUrl;
  final _userNameController = TextEditingController();

  final _phoneController = TextEditingController();
  final UserInformationValidator userInformationValidator =
      UserInformationValidator();

  String? _gender;
  String? _bloodGroup;
  DateTime? _dob;

  @override
  void dispose() {
    _userNameController.dispose();

    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    _userNameController.text = user.userName;
    _phoneController.text = user.phoneNo;
    if (user.userProfileImageUrl != null) {
      image = Image.network(user.userProfileImageUrl!);
    }

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserProfileImageSubmitFailure) {
          showSnackBar(context, state.message);
          Navigator.of(context).pop();
        }
        if (state is UserSubmittedFailure) {
          showSnackBar(context, state.message);
          Navigator.of(context).pop();
        }

        if (state is UserProfileImageSubmitSuccess) {
          imageUrl = state.imageUrl;
          context.read<UserBloc>().add(UserDataSubmittedRemotly(
              user: User(
                  userId: user.userId,
                  email: user.email,
                  userName: _userNameController.text,
                  dob: _dob!,
                  phoneNo: _phoneController.text,
                  cnic: user.cnic,
                  gender: _gender!,
                  bloodGroup: _bloodGroup!,
                  location: user.location,
                  fcmToken: user.fcmToken,
                  userProfileImageUrl: imageUrl)));
        }
        if (state is UserSubmittedSuccess) {
          context.read<UserCubit>().initializeUser(User(
              userId: user.userId,
              userName: _userNameController.text,
              dob: _dob!,
              phoneNo: _phoneController.text,
              email: user.email,
              cnic: user.cnic,
              gender: _gender!,
              bloodGroup: _bloodGroup!,
              location: user.location,
              fcmToken: user.fcmToken,
              userProfileImageUrl: imageUrl));
          showSnackBar(
              context, AppLocalizations.of(context)!.userProfile_dataUpdate);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.userProfile_myProfile),
            actions: [
              IconButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (!_key.currentState!.validate()) {
                      return;
                    }

                    final nonFormFieldValidation = userInformationValidator
                        .validateNonFormFieldValues(_bloodGroup, _gender);
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
                    _key.currentState!.save();
                    // Show loading dialog with disabled background
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Disable background tap to dismiss
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                    if (file == null) {
                      context.read<UserBloc>().add(UserDataSubmittedRemotly(
                          user: User(
                              userId: user.userId,
                              email: user.email,
                              userName: _userNameController.text,
                              dob: _dob!,
                              phoneNo: _phoneController.text,
                              cnic: user.cnic,
                              gender: _gender!,
                              bloodGroup: _bloodGroup!,
                              location: user.location,
                              fcmToken: user.fcmToken,
                              userProfileImageUrl: user.userProfileImageUrl)));
                    } else {
                      context
                          .read<UserBloc>()
                          .add(UserProfileImageSubmitted(file!));
                    }
                  },
                  icon: const Icon(Icons.check)),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _showImageSourceDialog,
                    child: CircleAvatar(
                      radius: 60,
                      foregroundImage: image?.image,
                      child: image == null
                          ? const Center(
                              child: Icon(CupertinoIcons.photo_camera),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _key,
                      child: Column(
                        children: [
                          ProfileFormField(
                            labelText:
                                AppLocalizations.of(context)!.userProfile_name,
                            validator:
                                userInformationValidator.userNameValidator,
                            controller: _userNameController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ProfileFormField(
                            labelText:
                                AppLocalizations.of(context)!.userProfile_phNo,
                            validator:
                                userInformationValidator.phoneNoValidator,
                            controller: _phoneController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DatePickerFormfield(
                            text: AppLocalizations.of(context)!.userProfile_dob,
                            currentValue: user.dob,
                            onSaved: (value) {
                              _dob = DateFormatter.stringToDate(value!);
                            },
                            validator: userInformationValidator.validateDOB,
                            isProfileView: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppLocalizations.of(context)!.userProfile_gender,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SelectGender(
                            initialValue: user.gender == 'male' ? true : false,
                            onChanged: (value) {
                              _gender = value ? 'male' : 'female';
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            AppLocalizations.of(context)!.userProfile_bGroup,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SelectBloodGroup(
                            initialValue: user.bloodGroup,
                            onChanged: (p0) {
                              _bloodGroup = p0;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            leading: const Icon(Icons.mail),
                            title: Text(
                              user.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(
                              TextFormatter.formatAddress(
                                  user.location.address),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.userProfile_imgSource),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: Text(AppLocalizations.of(context)!.userProfile_camera),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: Text(AppLocalizations.of(context)!.userProfile_gallery),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final imageData = await imagePicker.pickImage(source: source);
    if (imageData != null) {
      file = File(imageData.path);
      setState(() {
        image = Image.file(file!);
      });
    }
  }
}
