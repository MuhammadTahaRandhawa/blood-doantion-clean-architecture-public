import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

Map<String, String?> getGuidelinesConstantValues(BuildContext context) {
  return {
    AppLocalizations.of(context)!.donationVerification_weight:
        AppLocalizations.of(context)!.donationVerification_weightStatement,
    AppLocalizations.of(context)!.donationVerification_health:
        AppLocalizations.of(context)!.donationVerification_healthStatment,
    AppLocalizations.of(context)!.donationVerification_meditation:
        AppLocalizations.of(context)!.donationVerification_medistatment,
    AppLocalizations.of(context)!.donationVerification_timing:
        AppLocalizations.of(context)!.donationVerification_timingStatment,
    AppLocalizations.of(context)!.donationVerification_iHaveRead: null
  };
}
