import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/settings/domain/entities/current_app_language.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repositories.dart';

class SetCurrentAppLanguage implements Usecase<Unit, CurrentAppLanguage> {
  final SettingsRepository settingsRepository;

  SetCurrentAppLanguage(this.settingsRepository);
  @override
  Future<Either<Failure, Unit>> call(CurrentAppLanguage params) async {
    return await settingsRepository.setCurrentLangaugeType(params);
  }
}
