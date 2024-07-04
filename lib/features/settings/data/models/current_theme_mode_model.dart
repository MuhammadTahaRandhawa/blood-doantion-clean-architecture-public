import 'package:myapp/features/settings/domain/entities/theme_mode.dart';

class CurrrentThemeModeModel extends CurrentThemeMode {
  CurrrentThemeModeModel({required super.themeModeType});

  factory CurrrentThemeModeModel.fromCurrentThemeMode(
      CurrentThemeMode currentThemeMode) {
    return CurrrentThemeModeModel(
        themeModeType: currentThemeMode.themeModeType);
  }

  factory CurrrentThemeModeModel.fromString(String type) {
    switch (type) {
      case 'light':
        return CurrrentThemeModeModel(themeModeType: ThemeModeType.light);
      case 'dark':
        return CurrrentThemeModeModel(themeModeType: ThemeModeType.dark);
      case 'deviceCurrent':
        return CurrrentThemeModeModel(
            themeModeType: ThemeModeType.deviceCurrent);
      default:
        return CurrrentThemeModeModel(
            themeModeType: ThemeModeType.deviceCurrent);
    }
  }

  String getStringFromThemeMode() {
    switch (themeModeType) {
      case ThemeModeType.dark:
        return 'dark';
      case ThemeModeType.light:
        return 'light';
      case ThemeModeType.deviceCurrent:
        return 'deviceCurrent';
      default:
        return 'invalid theme type';
    }
  }
}
