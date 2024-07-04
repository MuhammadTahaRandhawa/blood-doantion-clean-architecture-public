import 'package:myapp/features/settings/domain/entities/current_app_language.dart';

class CurrentAppLangaugeModel extends CurrentAppLanguage {
  CurrentAppLangaugeModel(super.currentAppLanguageType);

  factory CurrentAppLangaugeModel.fromCurrentAppLanguage(
      CurrentAppLanguage currentAppLanguage) {
    return CurrentAppLangaugeModel(currentAppLanguage.currentAppLanguageType);
  }

  factory CurrentAppLangaugeModel.fromString(String type) {
    switch (type) {
      case 'urdu':
        return CurrentAppLangaugeModel(AppLanguageType.urdu);
      case 'english':
        return CurrentAppLangaugeModel(AppLanguageType.english);
      default:
        return CurrentAppLangaugeModel(AppLanguageType.english);
    }
  }

  String getStringFromCurrentAppLangaugeModel() {
    switch (currentAppLanguageType) {
      case AppLanguageType.english:
        return 'english';
      case AppLanguageType.urdu:
        return 'urdu';
      default:
        return 'invalid theme type';
    }
  }
}
