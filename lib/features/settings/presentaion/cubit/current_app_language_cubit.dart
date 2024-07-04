import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/features/settings/domain/entities/current_app_language.dart';
import 'package:myapp/features/settings/domain/usecases/get_current_app_language.dart';
import 'package:myapp/features/settings/domain/usecases/set_current_app_language.dart';

class CurrentAppLanguageCubit extends Cubit<CurrentAppLanguage> {
  final GetCurrentAppLanguage getCurrentAppLanguage;
  final SetCurrentAppLanguage setCurrentAppLanguage;
  CurrentAppLanguageCubit(
      this.getCurrentAppLanguage, this.setCurrentAppLanguage)
      : super(CurrentAppLanguage(null)) {
    getAppLanguage();
  }

  void getAppLanguage() async {
    final res = await getCurrentAppLanguage.call(unit);
    res.fold((l) => null, (r) => emit(r));
  }

  void setLanguage(AppLanguageType appLanguageType) async {
    final CurrentAppLanguage currentAppLanguage =
        CurrentAppLanguage(appLanguageType);
    final res = await setCurrentAppLanguage.call(currentAppLanguage);
    res.fold(
      (l) => null,
      (r) => emit(currentAppLanguage),
    );
  }

  Locale locale(AppLanguageType? appLanguageType) {
    if (appLanguageType == AppLanguageType.english) {
      return const Locale('en');
    } else if (appLanguageType == AppLanguageType.urdu) {
      return const Locale('ur');
    } else {
      return const Locale('en');
    }
  }
}
