import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/presentation/widgets/report_pop_up_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowMapImageContainer extends StatelessWidget {
  const ShowMapImageContainer({
    super.key,
    required this.mapsImage,
    this.height = 200,
    required this.reportType,
    required this.otherUserId,
    required this.reportTypeId,
  });
  final Widget? mapsImage;
  final double height;
  final ReportType reportType;
  final String otherUserId;
  final String reportTypeId;

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
                reportTypeId: reportTypeId,
                reportType: reportType,
                otherPartyId: otherUserId)),
      ],
    );
  }
}
