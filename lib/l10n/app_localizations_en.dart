// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get chooseChallengeTitle => 'Choose a challenge';

  @override
  String get newChallenge => 'New challenge';

  @override
  String get completedChallenges => 'Completed challenges';

  @override
  String get startChallenge => 'Start challenge';

  @override
  String get pauseChallenge => 'Pause challenge';

  @override
  String get stopChallenge => 'Stop challenge';

  @override
  String get endChallenge => 'End challenge';

  @override
  String get resumeChallenge => 'Resume challenge';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get steps => 'steps';

  @override
  String get points => 'points';

  @override
  String get level => 'level';

  @override
  String get termsTitle => 'Terms And Conditions';

  @override
  String get welcomeTo => 'Welcome to Stepit';

  @override
  String get agreeToTerms => 'I agree to the terms and conditions.';

  @override
  String get next => 'Next';

  @override
  String get ok => 'ok';

  @override
  String get termsBeforeProceed => 'Before you proceed, you must agree to our terms of service.';

  @override
  String get identificationTitle => 'Identification';

  @override
  String get uniqueNumberGetError => 'There was an error getting unique number.';

  @override
  String get userNameRegexMessage => 'Username must contain only letters and numbers, and it must be between 4 and 16 characters long';

  @override
  String get enterUserName => 'Enter a username to get started';

  @override
  String get loadingUniqueNumber => 'Unique number: loading...';

  @override
  String get uniqueNumber => 'Unique number:';

  @override
  String get uniqueNumberNotFound => 'Unique number: not found';

  @override
  String get done => 'Done';
}
