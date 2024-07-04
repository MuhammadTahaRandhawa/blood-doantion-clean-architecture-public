import 'package:flutter/material.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/presentation/widgets/report_pop_up_button.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestLocationDetailContainer extends StatelessWidget {
  const RequestLocationDetailContainer(
      {super.key,
      required this.mapsImage,
      this.height = 200,
      required this.address,
      required this.request});
  final Widget? mapsImage;
  final double height;
  final String address;
  final Request request;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all()),
          width: MediaQuery.of(context).size.width,
          height: height,
          child: mapsImage ??
              Center(
                child:
                    Text(AppLocalizations.of(context)!.reqLocMap_errorfetchImg),
              ),
        ),
        Positioned(
          left: 16,
          top: MediaQuery.of(context).padding.top + 16,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 16,
            child: CustomPopUpButton(
              reportTypeId: request.requestId,
              reportType: ReportType.request,
              otherPartyId: request.requestId,
            )),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                address,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
