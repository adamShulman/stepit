import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

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
    Locale('he')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @chooseChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a challenge'**
  String get chooseChallengeTitle;

  /// No description provided for @newChallenge.
  ///
  /// In en, this message translates to:
  /// **'New challenge'**
  String get newChallenge;

  /// No description provided for @completedChallenges.
  ///
  /// In en, this message translates to:
  /// **'Completed challenges'**
  String get completedChallenges;

  /// No description provided for @startChallenge.
  ///
  /// In en, this message translates to:
  /// **'Start challenge'**
  String get startChallenge;

  /// No description provided for @pauseChallenge.
  ///
  /// In en, this message translates to:
  /// **'Pause challenge'**
  String get pauseChallenge;

  /// No description provided for @stopChallenge.
  ///
  /// In en, this message translates to:
  /// **'Stop challenge'**
  String get stopChallenge;

  /// No description provided for @endChallenge.
  ///
  /// In en, this message translates to:
  /// **'End challenge'**
  String get endChallenge;

  /// No description provided for @resumeChallenge.
  ///
  /// In en, this message translates to:
  /// **'Resume challenge'**
  String get resumeChallenge;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'steps'**
  String get steps;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'level'**
  String get level;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms And Conditions'**
  String get termsTitle;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Stepit'**
  String get welcomeTo;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and conditions.'**
  String get agreeToTerms;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'ok'**
  String get ok;

  /// No description provided for @termsBeforeProceed.
  ///
  /// In en, this message translates to:
  /// **'Before you proceed, you must agree to our terms of service.'**
  String get termsBeforeProceed;

  /// No description provided for @identificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get identificationTitle;

  /// No description provided for @uniqueNumberGetError.
  ///
  /// In en, this message translates to:
  /// **'There was an error getting unique number.'**
  String get uniqueNumberGetError;

  /// No description provided for @userNameRegexMessage.
  ///
  /// In en, this message translates to:
  /// **'Username must contain only letters and numbers, and it must be between 4 and 16 characters long'**
  String get userNameRegexMessage;

  /// No description provided for @enterUserName.
  ///
  /// In en, this message translates to:
  /// **'Enter a username to get started'**
  String get enterUserName;

  /// No description provided for @loadingUniqueNumber.
  ///
  /// In en, this message translates to:
  /// **'Unique number: loading...'**
  String get loadingUniqueNumber;

  /// No description provided for @uniqueNumber.
  ///
  /// In en, this message translates to:
  /// **'Unique number:'**
  String get uniqueNumber;

  /// No description provided for @uniqueNumberNotFound.
  ///
  /// In en, this message translates to:
  /// **'Unique number: not found'**
  String get uniqueNumberNotFound;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'he': return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
