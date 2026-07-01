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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'SkillFix'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @shopping.
  ///
  /// In es, this message translates to:
  /// **'Compras'**
  String get shopping;

  /// No description provided for @maintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get maintenance;

  /// No description provided for @history.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get history;

  /// No description provided for @favorites.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favorites;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar idioma'**
  String get selectLanguage;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @searchHint.
  ///
  /// In es, this message translates to:
  /// **'¿Qué necesitas arreglar hoy?'**
  String get searchHint;

  /// No description provided for @popularProblems.
  ///
  /// In es, this message translates to:
  /// **'Problemas populares'**
  String get popularProblems;

  /// No description provided for @trades.
  ///
  /// In es, this message translates to:
  /// **'Oficios'**
  String get trades;

  /// No description provided for @quickDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico rápido'**
  String get quickDiagnosis;

  /// No description provided for @emergency.
  ///
  /// In es, this message translates to:
  /// **'Tengo una emergencia'**
  String get emergency;

  /// No description provided for @calculators.
  ///
  /// In es, this message translates to:
  /// **'Calculadoras'**
  String get calculators;

  /// No description provided for @viewGuide.
  ///
  /// In es, this message translates to:
  /// **'Ver guía'**
  String get viewGuide;

  /// No description provided for @watchOnYoutube.
  ///
  /// In es, this message translates to:
  /// **'Ver en YouTube'**
  String get watchOnYoutube;

  /// No description provided for @createShoppingList.
  ///
  /// In es, this message translates to:
  /// **'Crear lista de compras'**
  String get createShoppingList;

  /// No description provided for @addToFavorites.
  ///
  /// In es, this message translates to:
  /// **'Agregar a favoritos'**
  String get addToFavorites;

  /// No description provided for @savedToFavorites.
  ///
  /// In es, this message translates to:
  /// **'Agregado a favoritos'**
  String get savedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In es, this message translates to:
  /// **'Eliminado de favoritos'**
  String get removedFromFavorites;

  /// No description provided for @markAsCompleted.
  ///
  /// In es, this message translates to:
  /// **'Marcar como completada'**
  String get markAsCompleted;

  /// No description provided for @completed.
  ///
  /// In es, this message translates to:
  /// **'Completada'**
  String get completed;

  /// No description provided for @alreadyCompleted.
  ///
  /// In es, this message translates to:
  /// **'Esta guía ya está completada'**
  String get alreadyCompleted;

  /// No description provided for @requestTechnician.
  ///
  /// In es, this message translates to:
  /// **'Pedir ayuda a un técnico'**
  String get requestTechnician;

  /// No description provided for @couldNotFixIt.
  ///
  /// In es, this message translates to:
  /// **'No pude resolverlo'**
  String get couldNotFixIt;

  /// No description provided for @soonFixRadar.
  ///
  /// In es, this message translates to:
  /// **'Próximamente podrás solicitar un técnico calificado desde FixRadar directamente desde esta pantalla.\n\nEstamos trabajando para conectar esta funcionalidad.'**
  String get soonFixRadar;

  /// No description provided for @noFavoritesYet.
  ///
  /// In es, this message translates to:
  /// **'No tienes favoritos todavía'**
  String get noFavoritesYet;

  /// No description provided for @noShoppingListsYet.
  ///
  /// In es, this message translates to:
  /// **'No tienes listas de compras todavía'**
  String get noShoppingListsYet;

  /// No description provided for @noHistoryYet.
  ///
  /// In es, this message translates to:
  /// **'No tienes reparaciones registradas todavía'**
  String get noHistoryYet;

  /// No description provided for @noRemindersYet.
  ///
  /// In es, this message translates to:
  /// **'No tienes recordatorios todavía'**
  String get noRemindersYet;

  /// No description provided for @diyEvaluationTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Puedo hacerlo yo o necesito técnico?'**
  String get diyEvaluationTitle;

  /// No description provided for @requiredExperience.
  ///
  /// In es, this message translates to:
  /// **'Experiencia'**
  String get requiredExperience;

  /// No description provided for @safetyReminder.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio'**
  String get safetyReminder;

  /// No description provided for @finalRecommendation.
  ///
  /// In es, this message translates to:
  /// **'Recomendación final'**
  String get finalRecommendation;

  /// No description provided for @tryIf.
  ///
  /// In es, this message translates to:
  /// **'Puedes intentarlo si...'**
  String get tryIf;

  /// No description provided for @callIf.
  ///
  /// In es, this message translates to:
  /// **'Mejor llama a un técnico si...'**
  String get callIf;

  /// No description provided for @toolsNeeded.
  ///
  /// In es, this message translates to:
  /// **'Herramientas necesarias'**
  String get toolsNeeded;

  /// No description provided for @materialsNeeded.
  ///
  /// In es, this message translates to:
  /// **'Materiales necesarios'**
  String get materialsNeeded;

  /// No description provided for @stepsToFollow.
  ///
  /// In es, this message translates to:
  /// **'Pasos a seguir'**
  String get stepsToFollow;

  /// No description provided for @safetyWarnings.
  ///
  /// In es, this message translates to:
  /// **'Advertencias de seguridad'**
  String get safetyWarnings;

  /// No description provided for @evaluateMyCase.
  ///
  /// In es, this message translates to:
  /// **'Evaluar mi caso'**
  String get evaluateMyCase;

  /// No description provided for @estimatedTime.
  ///
  /// In es, this message translates to:
  /// **'tiempo estimado'**
  String get estimatedTime;

  /// No description provided for @risk.
  ///
  /// In es, this message translates to:
  /// **'Riesgo'**
  String get risk;

  /// No description provided for @difficulty.
  ///
  /// In es, this message translates to:
  /// **'Dificultad'**
  String get difficulty;

  /// No description provided for @easy.
  ///
  /// In es, this message translates to:
  /// **'Fácil'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In es, this message translates to:
  /// **'Difícil'**
  String get hard;

  /// No description provided for @low.
  ///
  /// In es, this message translates to:
  /// **'Bajo'**
  String get low;

  /// No description provided for @high.
  ///
  /// In es, this message translates to:
  /// **'Alto'**
  String get high;

  /// No description provided for @critical.
  ///
  /// In es, this message translates to:
  /// **'Crítico'**
  String get critical;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Próximamente'**
  String get comingSoon;

  /// No description provided for @understood.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get understood;

  /// No description provided for @errorOpeningYoutube.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir YouTube'**
  String get errorOpeningYoutube;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
