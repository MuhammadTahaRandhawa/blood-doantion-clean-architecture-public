import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/features/settings/domain/entities/theme_mode.dart';
import 'package:myapp/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:myapp/features/settings/domain/usecases/set_theme_mode.dart';

class ThemeModeCubit extends Cubit<CurrentThemeMode> {
  final GetThemeMode getThemeMode;
  final SetThemeMode setThemeMode;
  ThemeModeCubit(this.getThemeMode, this.setThemeMode)
      : super(CurrentThemeMode(themeModeType: null)) {
    getTheme();
  }

  void getTheme() async {
    final res = await getThemeMode.call(unit);
    res.fold((l) => null, (r) => emit(r));
  }

  void setTheme(ThemeModeType themeModeType) async {
    final CurrentThemeMode currentThemeMode =
        CurrentThemeMode(themeModeType: themeModeType);
    final res = await setThemeMode.call(currentThemeMode);
    res.fold(
      (l) => null,
      (r) => emit(currentThemeMode),
    );
  }

  ThemeMode themeMode(ThemeModeType? theme) {
    if (theme == ThemeModeType.dark) {
      return ThemeMode.dark;
    } else if (theme == ThemeModeType.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }
}
