import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/settings/domain/entities/current_app_language.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repositories.dart';

class GetCurrentAppLanguage implements Usecase<CurrentAppLanguage, Unit> {
  final SettingsRepository settingsRepository;

  GetCurrentAppLanguage(this.settingsRepository);
  @override
  Future<Either<Failure, CurrentAppLanguage>> call(Unit params) async {
    return settingsRepository.fetchCurrentAppLanguageType();
  }
}
