import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/features/settings/data/models/current_app_language_model.dart';
import 'package:myapp/features/settings/data/models/current_theme_mode_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsLocalDataSource {
  CurrrentThemeModeModel fetchCurrentThemeMode();
  Future<Unit> setCurrentThemeMode(
      CurrrentThemeModeModel currrentThemeModeModel);
  CurrentAppLangaugeModel fetchCurrentAppLanguageType();
  Future<Unit> setCurrentAppLanguageType(
      CurrentAppLangaugeModel currentAppLangaugeModel);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sp;

  SettingsLocalDataSourceImpl(this.sp);
  @override
  CurrrentThemeModeModel fetchCurrentThemeMode() {
    try {
      final themeMode = sp.getString('theme_mode');
      return CurrrentThemeModeModel.fromString(themeMode ?? '');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> setCurrentThemeMode(
      CurrrentThemeModeModel currrentThemeModeModel) async {
    try {
      await sp.setString(
          'theme_mode', currrentThemeModeModel.getStringFromThemeMode());
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  CurrentAppLangaugeModel fetchCurrentAppLanguageType() {
    try {
      final currentAppLangauge = sp.getString('current_app_language');
      return CurrentAppLangaugeModel.fromString(currentAppLangauge ?? '');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> setCurrentAppLanguageType(
      CurrentAppLangaugeModel currentAppLangaugeModel) async {
    try {
      await sp.setString('current_app_language',
          currentAppLangaugeModel.getStringFromCurrentAppLangaugeModel());
      return unit;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
