import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/appointments/domain/entities/appointment.dart';
import 'package:myapp/core/features/appointments/presentation/widgets/appointment_show_map_image_conatiner.dart';
import 'package:myapp/core/features/maps/presentation/bloc/maps_bloc.dart';
import 'package:myapp/core/utilis/date_formatter.dart';
import 'package:myapp/core/utilis/geo_flutter_fire.dart';
import 'package:myapp/core/widgets/detail_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.appointment});
  final Appointment appointment;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  Image? mapsImage;
  bool? isLoading;

  @override
  void initState() {
    context.read<MapsBloc>().add(MapsStaticImageFetched(LatitudeLongitude(
        latitude: widget.appointment.appointmentLocation.latitude,
        longitude: widget.appointment.appointmentLocation.longitude)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final currentUser = context.watch<UserCubit>().state;

    return Scaffold(
      body: SingleChildScrollView(
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
              child: AppointmentShowMapImageContainer(
                address: widget.appointment.appointmentLocation.address,
                height: MediaQuery.of(context).size.height * 0.4,
                mapsImage: mapsImage ??
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.timelapse),
                  title: Text(widget.appointment.appointmentDateTime != null
                      ? DateFormatter.convertChatDateTimeToString(
                          widget.appointment.appointmentDateTime!)
                      : AppLocalizations.of(context)!.apponitDetail_no),
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: DetailFormField(
                labelText: AppLocalizations.of(context)!.apponitDetail_name,
                currentValue: widget.appointment.appointmentParticipantName,
              ),
            ),
            if (widget.appointment.appointmentOtherPartyType ==
                AppointmentOtherParty.user)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: DetailFormField(
                  labelText: AppLocalizations.of(context)!.apponitDetail_phNo,
                  currentValue: widget.appointment.appointmentCreaterPhoneNo,
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: DetailFormField(
                labelText: AppLocalizations.of(context)!.apponitDetail_bGroup,
                currentValue: widget.appointment.bloodGroup,
              ),
            ),
            if (widget.appointment.appointmentType == AppointmentType.request)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: DetailFormField(
                  labelText:
                      AppLocalizations.of(context)!.apponitDetail_bloodBags,
                  currentValue: widget.appointment.bloodBags?.toString() ??
                      AppLocalizations.of(context)!.apponitDetail_no,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
