import 'package:flutter/material.dart';
import 'package:myapp/features/blood_centers/domain/entities/blood_center.dart';
import 'package:myapp/features/blood_centers/presentation/pages/blood_center_appointment_page.dart';
import 'package:myapp/features/blood_centers/presentation/pages/blood_center_detail_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodCenterCard extends StatelessWidget {
  const BloodCenterCard({
    super.key,
    required this.bloodCenter,
  });

  final BloodCenter bloodCenter;

  @override
  Widget build(BuildContext context) {
    // final currentUser = context.watch<UserCubit>().state;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(children: [
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: CircleAvatar(
            radius: 40,
            // foregroundImage:
            //    request. != null ? NetworkImage(userImageUrl!) : null,
            child: Center(
              child: Text(bloodCenter.centerName.substring(0, 1).toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                bloodCenter.centerName,
                style: const TextStyle().copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                bloodCenter.centerLocation.address,
                style: const TextStyle().copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              BloodCenterDetailPage(bloodCenter: bloodCenter),
                        ));
                      },
                      child: Text(
                          AppLocalizations.of(context)!.bloodCenterCard_view)),
                  FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              BloodCenterScheduleAppointmentPage(
                            bloodCenter: bloodCenter,
                          ),
                        ));
                      },
                      child: Text(AppLocalizations.of(context)!
                          .bloodCenterCard_Schedule))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ]),
    );
  }
}
