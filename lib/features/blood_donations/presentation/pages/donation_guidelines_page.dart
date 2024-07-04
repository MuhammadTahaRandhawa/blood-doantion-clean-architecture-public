import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/pages/bottom_navigation_bar.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/core/widgets/large_gradient_button.dart';
import 'package:myapp/features/blood_donations/domain/entities/donation.dart';
import 'package:myapp/features/blood_donations/presentation/bloc/blood_donation_bloc.dart';
import 'package:myapp/features/blood_donations/presentation/const/donation_verification_const.dart';
import 'package:myapp/features/blood_donations/presentation/widgets/guideline_check.dart';

class DonationGuidelinesPage extends StatefulWidget {
  const DonationGuidelinesPage({super.key});

  @override
  State<DonationGuidelinesPage> createState() => _DonationGuidelinesPageState();
}

class _DonationGuidelinesPageState extends State<DonationGuidelinesPage> {
  Map<String, String?> guidelines = {};
  List<bool> checkValues = [];

  @override
  void initState() {
    super.initState();
    // Initialize the guidelines map using the context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        guidelines = getGuidelinesConstantValues(context);
        checkValues = guidelines.entries.map((_) => false).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    return BlocListener<BloodDonationBloc, BloodDonationState>(
      listener: (context, state) {
        if (state is BloodDonationPostLoading) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is BloodDonationPostFailure) {
          showSnackBar(context, state.message);
        }
        if (state is BloodDonationPostSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AppBottomNavigation(),
              ),
              (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: guidelines.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.donationGuid_Guidline,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Text(AppLocalizations.of(context)!
                              .donationGuid_ReadCarefully),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => GuidelineCheck(
                          head: guidelines.keys.toList()[index],
                          text: guidelines.values.toList()[index],
                          checkValue: checkValues[index],
                          onChanged: (value) {
                            setState(() {
                              checkValues[index] = value;
                            });
                          },
                        ),
                        itemCount: guidelines.length,
                      ),
                    ),
                    const SizedBox(height: 30),
                    LargeGradientButton(
                      isDisabled: !checkValues.last,
                      onPressed: () {
                        context
                            .read<BloodDonationBloc>()
                            .add(BloodDonationPosted(Donation(
                              userId: user.userId,
                              userName: user.userName,
                              isActive: true,
                              dob: user.dob,
                              phoneNo: user.phoneNo,
                              email: user.email,
                              cnic: user.cnic,
                              gender: user.gender,
                              bloodGroup: user.bloodGroup,
                              location: user.location,
                              fcmToken: user.fcmToken,
                              userProfileImageUrl: user.userProfileImageUrl,
                            )));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.donationGuid_AgreeCont,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
