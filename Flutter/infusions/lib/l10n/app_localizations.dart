import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Infusions Calculator'**
  String get appTitle;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved.'**
  String get allRightsReserved;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get errorGenericMessage;

  /// No description provided for @errorDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Error Details'**
  String get errorDetailsLabel;

  /// No description provided for @buttonBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get buttonBackToHome;

  /// No description provided for @selectThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Select Theme Mode'**
  String get selectThemeMode;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get systemTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageAndTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme and Language'**
  String get selectLanguageAndTheme;

  /// No description provided for @calculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculator;

  /// No description provided for @error404.
  ///
  /// In en, this message translates to:
  /// **'Error 404'**
  String get error404;

  /// No description provided for @error404details.
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get error404details;

  /// No description provided for @infusionCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Infusion\nCalculator'**
  String get infusionCalculatorTitle;

  /// No description provided for @infusionCalculatorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dose, Rate and Concentration'**
  String get infusionCalculatorSubtitle;

  /// No description provided for @mixture.
  ///
  /// In en, this message translates to:
  /// **'MIXTURE'**
  String get mixture;

  /// No description provided for @preloaded.
  ///
  /// In en, this message translates to:
  /// **'Preloaded'**
  String get preloaded;

  /// No description provided for @drugDose.
  ///
  /// In en, this message translates to:
  /// **'Drug Dose'**
  String get drugDose;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @totalVolumeMl.
  ///
  /// In en, this message translates to:
  /// **'Total Volume (ml)'**
  String get totalVolumeMl;

  /// No description provided for @concentration.
  ///
  /// In en, this message translates to:
  /// **'Concentration:'**
  String get concentration;

  /// No description provided for @calculateDoseByWeight.
  ///
  /// In en, this message translates to:
  /// **'Calculate dose by Weight (kg)'**
  String get calculateDoseByWeight;

  /// No description provided for @patientWeight.
  ///
  /// In en, this message translates to:
  /// **'Patient Weight'**
  String get patientWeight;

  /// No description provided for @getDose.
  ///
  /// In en, this message translates to:
  /// **'Get dose'**
  String get getDose;

  /// No description provided for @getRate.
  ///
  /// In en, this message translates to:
  /// **'Get rate'**
  String get getRate;

  /// No description provided for @pumpRateInput.
  ///
  /// In en, this message translates to:
  /// **'Pump Rate'**
  String get pumpRateInput;

  /// No description provided for @desiredDose.
  ///
  /// In en, this message translates to:
  /// **'Desired Dose'**
  String get desiredDose;

  /// No description provided for @showIn.
  ///
  /// In en, this message translates to:
  /// **'Show in:'**
  String get showIn;

  /// No description provided for @infusedDose.
  ///
  /// In en, this message translates to:
  /// **'INFUSED DOSE'**
  String get infusedDose;

  /// No description provided for @pumpRateResult.
  ///
  /// In en, this message translates to:
  /// **'PUMP RATE'**
  String get pumpRateResult;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
