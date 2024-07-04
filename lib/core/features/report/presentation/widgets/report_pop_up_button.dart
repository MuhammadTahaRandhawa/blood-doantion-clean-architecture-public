import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/app_user/domain/entities/user.dart';
import 'package:myapp/core/features/app_user/presentation/bloc/user_bloc.dart';
import 'package:myapp/core/features/app_user/presentation/cubit/user_cubit.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';
import 'package:myapp/core/features/report/presentation/bloc/report_bloc.dart';
import 'package:myapp/core/utilis/snackbar.dart';
import 'package:myapp/features/profile/presentation/pages/about_user_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomPopUpButton extends StatefulWidget {
  const CustomPopUpButton(
      {super.key,
      required this.reportTypeId,
      required this.reportType,
      required this.otherPartyId});
  final String reportTypeId;
  final String otherPartyId;
  final ReportType reportType;

  @override
  State<CustomPopUpButton> createState() => _CustomPopUpButtonState();
}

class _CustomPopUpButtonState extends State<CustomPopUpButton> {
  bool _isLoading = false;
  final Map<int, String> data = {
    0: 'Spam or Misleading',
    1: 'Violent or Repulsive',
    2: 'Hateful or Abusive',
    3: 'Other'
  };
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UserCubit>().state;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is OtherUserDataFetchedSuccess) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AboutUserPage(user: state.user),
          ));
        }
        if (state is OtherUserDataFetchedFailure) {
          setState(() {
            _isLoading = false;
          });
          showSnackBar(context, state.message);
        }
        if (state is OtherUserDataFetchedLoading) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: PopupMenuButton(
          itemBuilder: (context) => [
                PopupMenuItem(
                  child: TextButton.icon(
                    onPressed: () => _showReportDialog(currentUser),
                    icon: const Icon(Icons.report),
                    label:
                        Text(AppLocalizations.of(context)!.reportPopBtn_report),
                  ),
                ),
                if (widget.reportType != ReportType.centre)
                  PopupMenuItem(
                    child: TextButton.icon(
                      onPressed: () {
                        context
                            .read<UserBloc>()
                            .add(OtherUserDataFethed(widget.otherPartyId));
                      },
                      icon: const Icon(Icons.person),
                      label: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(AppLocalizations.of(context)!
                              .reportPopBtn_viewProfile),
                    ),
                  ),
              ]),
    );
  }

  void _showReportDialog(User currentUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.reportPopBtn_selectreport),
          content: SingleChildScrollView(
            child: ListBody(
              children: data.entries.map((type) {
                return CheckboxListTile(
                  value: type.key == selected,
                  title: Text(type.value),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value! == true) {
                        selected = type.key;
                      }
                    });
                    Navigator.pop(context);
                    _showReportDialog(currentUser);
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.reportPopBtn_cancle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.reportPopBtn_ok),
              onPressed: () {
                context.read<ReportBloc>().add(ReportOnRequestPosted(
                    widget.reportTypeId,
                    Report(
                      reportType: widget.reportType,
                      userName: currentUser.userName,
                      userId: currentUser.userId,
                      text: data[selected]!,
                      timestamp: DateTime.now(),
                    )));
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
