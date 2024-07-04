import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/usecase/usecase.dart';
import 'package:myapp/features/settings/domain/entities/theme_mode.dart';
import 'package:myapp/features/settings/domain/repositories/settings_repositories.dart';

class SetThemeMode implements Usecase<Unit, CurrentThemeMode> {
  final SettingsRepository settingsRepository;

  SetThemeMode(this.settingsRepository);
  @override
  Future<Either<Failure, Unit>> call(CurrentThemeMode params) async {
    return await settingsRepository.setCurrentThemeMode(params);
  }
}
