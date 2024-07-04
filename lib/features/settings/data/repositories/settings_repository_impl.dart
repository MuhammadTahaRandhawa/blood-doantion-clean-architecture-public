import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:myapp/features/settings/data/models/current_app_language_model.dart';
import 'package:myapp/features/settings/data/models/current_theme_mode_model.dart';
import 'package:myapp/features/settings/domain/entities/current_app_language.dart';
import 'package:myapp/features/settings/domain/entities/theme_mode.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repositories.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource settingsLocalDataSource;

  SettingsRepositoryImpl(this.settingsLocalDataSource);
  @override
  Either<Failure, CurrentThemeMode> fetchCurrentThemeMode() {
    try {
      final res = settingsLocalDataSource.fetchCurrentThemeMode();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> setCurrentThemeMode(
      CurrentThemeMode currentThemeMode) async {
    try {
      final res = await settingsLocalDataSource.setCurrentThemeMode(
          CurrrentThemeModeModel.fromCurrentThemeMode(currentThemeMode));
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }

  @override
  Either<Failure, CurrentAppLanguage> fetchCurrentAppLanguageType() {
    try {
      final res = settingsLocalDataSource.fetchCurrentAppLanguageType();
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setCurrentLangaugeType(
      CurrentAppLanguage currentAppLanguage) async {
    try {
      final res = await settingsLocalDataSource.setCurrentAppLanguageType(
          CurrentAppLangaugeModel.fromCurrentAppLanguage(currentAppLanguage));
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.exceptionMessage));
    }
  }
}
