import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ToggleAppointmentStatusButtons extends StatefulWidget {
  const ToggleAppointmentStatusButtons(
      {super.key, required this.selectedTabIndex, required this.onChangeTab});

  final int selectedTabIndex;
  final Function(int) onChangeTab;

  @override
  State<ToggleAppointmentStatusButtons> createState() =>
      _ToggleAppointmentStatusButtonsState();
}

class _ToggleAppointmentStatusButtonsState
    extends State<ToggleAppointmentStatusButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.selectedTabIndex == 0
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        foregroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      widget.onChangeTab(0);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .toogleAppointStatus_pending),
                  )
                : TextButton(
                    onPressed: () {
                      widget.onChangeTab(0);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.toogleAppointStatus_pending,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                  ),
            widget.selectedTabIndex == 1
                ? ElevatedButton(
                    onPressed: () {
                      widget.onChangeTab(1);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .toogleAppointStatus_approve),
                  )
                : TextButton(
                    onPressed: () {
                      widget.onChangeTab(1);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.toogleAppointStatus_approve,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                  ),
            widget.selectedTabIndex == 2
                ? ElevatedButton(
                    onPressed: () {
                      widget.onChangeTab(2);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .toogleAppointStatus_inProgress),
                  )
                : TextButton(
                    onPressed: () {
                      widget.onChangeTab(2);
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .toogleAppointStatus_inProgress,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                  ),
            widget.selectedTabIndex == 3
                ? ElevatedButton(
                    onPressed: () {
                      widget.onChangeTab(3);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .toogleAppointStatus_complete),
                  )
                : TextButton(
                    onPressed: () {
                      widget.onChangeTab(3);
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .toogleAppointStatus_complete,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                  ),
            widget.selectedTabIndex == 4
                ? ElevatedButton(
                    onPressed: () {
                      widget.onChangeTab(4);
                    },
                    child: Text(AppLocalizations.of(context)!
                        .toogleAppointStatus_cancelled),
                  )
                : TextButton(
                    onPressed: () {
                      widget.onChangeTab(4);
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .toogleAppointStatus_cancelled,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
