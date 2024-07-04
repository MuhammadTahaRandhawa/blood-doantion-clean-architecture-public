enum ThemeModeType { dark, light, deviceCurrent }

class CurrentThemeMode {
  CurrentThemeMode({required this.themeModeType});
  ThemeModeType? themeModeType;
}
