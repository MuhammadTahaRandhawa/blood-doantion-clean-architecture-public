import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/settings/domain/entities/theme_mode.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repositories.dart';

class GetThemeMode implements Usecase<CurrentThemeMode, Unit> {
  final SettingsRepository settingsRepository;

  GetThemeMode(this.settingsRepository);
  @override
  Future<Either<Failure, CurrentThemeMode>> call(Unit params) async {
    return settingsRepository.fetchCurrentThemeMode();
  }
}
