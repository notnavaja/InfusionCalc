// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calculadora de Infuciones';

  @override
  String get allRightsReserved => 'Todos los derechos reservados.';

  @override
  String get errorGenericTitle => 'Ha ocurrido un error';

  @override
  String get errorGenericMessage => 'Algo salió mal. Por favor, inténtalo de nuevo más tarde.';

  @override
  String get errorDetailsLabel => 'Detalles del Error';

  @override
  String get buttonBackToHome => 'Back to Home';

  @override
  String get selectThemeMode => 'Selecciona el Tema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get systemTheme => 'Auto';

  @override
  String get selectLanguage => 'Selecciona el Lenguaje';

  @override
  String get selectLanguageAndTheme => 'Selecciona el Tema y Lenguaje';

  @override
  String get calculator => 'Calculadora';

  @override
  String get error404 => 'Error 404';

  @override
  String get error404details => 'Detalles tecnicos';

  @override
  String get infusionCalculatorTitle => 'Calculadora de\nInfusiones';

  @override
  String get infusionCalculatorSubtitle => 'Dosis, Velocidad y Concentración';

  @override
  String get mixture => 'MEZCLA';

  @override
  String get preloaded => 'Precargados';

  @override
  String get drugDose => 'Dosis Fármaco';

  @override
  String get unit => 'Unidad';

  @override
  String get totalVolumeMl => 'Volumen Total (ml)';

  @override
  String get concentration => 'Concentración:';

  @override
  String get calculateDoseByWeight => 'Calcular dosis por Peso (kg)';

  @override
  String get patientWeight => 'Peso del paciente';

  @override
  String get getDose => 'Obtener dosis';

  @override
  String get getRate => 'Obtener velocidad';

  @override
  String get pumpRateInput => 'Velocidad Bomba';

  @override
  String get desiredDose => 'Dosis Deseada';

  @override
  String get showIn => 'Mostrar en:';

  @override
  String get infusedDose => 'DOSIS INFUNDIDA';

  @override
  String get pumpRateResult => 'VELOCIDAD BOMBA';

  @override
  String get pending => 'Pendiente';
}
