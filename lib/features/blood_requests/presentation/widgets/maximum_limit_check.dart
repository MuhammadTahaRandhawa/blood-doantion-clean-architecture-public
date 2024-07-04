import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/cubit/bottom_navigation_bar_index_cubit.dart';
import 'package:myapp/core/features/bottom_naviagtion/presentation/pages/bottom_navigation_bar.dart';
import 'package:myapp/features/blood_requests/domain/entities/request.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void checkMaxiumLimit(BuildContext context, List<Request> userRequestsToday) {
  if (userRequestsToday.length == 2) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          title: Row(
            children: [
              Text(
                AppLocalizations.of(context)!.maxLimChk_reachLim,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const AppBottomNavigation(),
                      ),
                      (route) => false);
                  context.read<BottomNavigationBarIndexCubit>().updateIndex(1);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          content: Text(
            AppLocalizations.of(context)!.maxLimChk_twiceAReq,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AppBottomNavigation(),
                    ),
                    (route) => false);
                context.read<BottomNavigationBarIndexCubit>().updateIndex(1);
              },
              child: Text(AppLocalizations.of(context)!.maxLimChk_okBtn),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    });
  }
}
