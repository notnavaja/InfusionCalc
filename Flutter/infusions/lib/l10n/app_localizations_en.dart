// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Infusions Calculator';

  @override
  String get allRightsReserved => 'All rights reserved.';

  @override
  String get errorGenericTitle => 'An error occurred';

  @override
  String get errorGenericMessage => 'Something went wrong. Please try again later.';

  @override
  String get errorDetailsLabel => 'Error Details';

  @override
  String get buttonBackToHome => 'Back to Home';

  @override
  String get selectThemeMode => 'Select Theme Mode';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'Auto';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectLanguageAndTheme => 'Select Theme and Language';

  @override
  String get calculator => 'Calculator';

  @override
  String get error404 => 'Error 404';

  @override
  String get error404details => 'Technical Details';

  @override
  String get infusionCalculatorTitle => 'Infusion\nCalculator';

  @override
  String get infusionCalculatorSubtitle => 'Dose, Rate and Concentration';

  @override
  String get mixture => 'MIXTURE';

  @override
  String get preloaded => 'Preloaded';

  @override
  String get drugDose => 'Drug Dose';

  @override
  String get unit => 'Unit';

  @override
  String get totalVolumeMl => 'Total Volume (ml)';

  @override
  String get concentration => 'Concentration:';

  @override
  String get calculateDoseByWeight => 'Calculate dose by Weight (kg)';

  @override
  String get patientWeight => 'Patient Weight';

  @override
  String get getDose => 'Get dose';

  @override
  String get getRate => 'Get rate';

  @override
  String get pumpRateInput => 'Pump Rate';

  @override
  String get desiredDose => 'Desired Dose';

  @override
  String get showIn => 'Show in:';

  @override
  String get infusedDose => 'INFUSED DOSE';

  @override
  String get pumpRateResult => 'PUMP RATE';

  @override
  String get pending => 'Pending';
}
