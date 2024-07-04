import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/settings/domain/entities/current_app_language.dart';
import 'package:myapp/features/settings/domain/entities/theme_mode.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, Unit>> setCurrentThemeMode(
      CurrentThemeMode currentThemeMode);
  Either<Failure, CurrentThemeMode> fetchCurrentThemeMode();

  Future<Either<Failure, Unit>> setCurrentLangaugeType(
      CurrentAppLanguage currentAppLanguage);
  Either<Failure, CurrentAppLanguage> fetchCurrentAppLanguageType();
}
