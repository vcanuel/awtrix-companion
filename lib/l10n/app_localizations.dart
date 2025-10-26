import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('fr'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'AWTRIX Companion'**
  String get appTitle;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @matrix.
  ///
  /// In en, this message translates to:
  /// **'Matrix'**
  String get matrix;

  /// No description provided for @autoBrightness.
  ///
  /// In en, this message translates to:
  /// **'Auto Brightness'**
  String get autoBrightness;

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// No description provided for @autoTransition.
  ///
  /// In en, this message translates to:
  /// **'Auto Transition'**
  String get autoTransition;

  /// No description provided for @matrixOff.
  ///
  /// In en, this message translates to:
  /// **'Matrix off'**
  String get matrixOff;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @reboot.
  ///
  /// In en, this message translates to:
  /// **'Reboot'**
  String get reboot;

  /// No description provided for @rebootDevice.
  ///
  /// In en, this message translates to:
  /// **'Reboot device'**
  String get rebootDevice;

  /// No description provided for @rebootConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reboot'**
  String get rebootConfirmTitle;

  /// No description provided for @rebootConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reboot the device?'**
  String get rebootConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @rebooting.
  ///
  /// In en, this message translates to:
  /// **'Rebooting...'**
  String get rebooting;

  /// No description provided for @turnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get turnOn;

  /// No description provided for @turnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get turnOff;

  /// No description provided for @turnOnMatrix.
  ///
  /// In en, this message translates to:
  /// **'Turn on LED matrix'**
  String get turnOnMatrix;

  /// No description provided for @turnOffMatrix.
  ///
  /// In en, this message translates to:
  /// **'Turn off LED matrix'**
  String get turnOffMatrix;

  /// No description provided for @turnOffConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get turnOffConfirmTitle;

  /// No description provided for @turnOffConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to turn off the LED matrix?'**
  String get turnOffConfirmMessage;

  /// No description provided for @matrixTurnedOn.
  ///
  /// In en, this message translates to:
  /// **'LED matrix turned on'**
  String get matrixTurnedOn;

  /// No description provided for @matrixTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'LED matrix turned off'**
  String get matrixTurnedOff;

  /// No description provided for @sleepMode.
  ///
  /// In en, this message translates to:
  /// **'Sleep mode'**
  String get sleepMode;

  /// No description provided for @sleepModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Put device in deep sleep'**
  String get sleepModeDescription;

  /// No description provided for @sleepDuration.
  ///
  /// In en, this message translates to:
  /// **'Sleep duration in seconds:'**
  String get sleepDuration;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour = 3600s'**
  String get oneHour;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @sleepActivated.
  ///
  /// In en, this message translates to:
  /// **'Sleep mode activated for {duration}s'**
  String sleepActivated(int duration);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Loading error'**
  String get loadingError;

  /// No description provided for @settingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Settings updated'**
  String get settingsUpdated;

  /// No description provided for @awtrixServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AWTRIX service unavailable'**
  String get awtrixServiceUnavailable;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @enterText.
  ///
  /// In en, this message translates to:
  /// **'Enter your notification text'**
  String get enterText;

  /// No description provided for @enterTextHint.
  ///
  /// In en, this message translates to:
  /// **'Enter text'**
  String get enterTextHint;

  /// No description provided for @sendAsApp.
  ///
  /// In en, this message translates to:
  /// **'Send as app'**
  String get sendAsApp;

  /// No description provided for @sendAsAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a custom app instead of a temporary notification'**
  String get sendAsAppDescription;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'App name'**
  String get appName;

  /// No description provided for @appNameDefault.
  ///
  /// In en, this message translates to:
  /// **'companion'**
  String get appNameDefault;

  /// No description provided for @appNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Unique identifier for the custom app'**
  String get appNameHelper;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @iconId.
  ///
  /// In en, this message translates to:
  /// **'Icon (ID)'**
  String get iconId;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get chooseIcon;

  /// No description provided for @textColor.
  ///
  /// In en, this message translates to:
  /// **'Text color'**
  String get textColor;

  /// No description provided for @textEffects.
  ///
  /// In en, this message translates to:
  /// **'Text effects'**
  String get textEffects;

  /// No description provided for @blink.
  ///
  /// In en, this message translates to:
  /// **'Blink (ms)'**
  String get blink;

  /// No description provided for @blinkHelper.
  ///
  /// In en, this message translates to:
  /// **'Blink interval in milliseconds'**
  String get blinkHelper;

  /// No description provided for @fade.
  ///
  /// In en, this message translates to:
  /// **'Fade (ms)'**
  String get fade;

  /// No description provided for @fadeHelper.
  ///
  /// In en, this message translates to:
  /// **'Fade interval in milliseconds'**
  String get fadeHelper;

  /// No description provided for @rainbowEffect.
  ///
  /// In en, this message translates to:
  /// **'Rainbow effect'**
  String get rainbowEffect;

  /// No description provided for @rainbowEffectDescription.
  ///
  /// In en, this message translates to:
  /// **'Scrolls each letter through the RGB spectrum'**
  String get rainbowEffectDescription;

  /// No description provided for @backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get backgroundColor;

  /// No description provided for @backgroundColorDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a custom background color'**
  String get backgroundColorDescription;

  /// No description provided for @chooseBackgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Choose background color'**
  String get chooseBackgroundColor;

  /// No description provided for @overlayEffect.
  ///
  /// In en, this message translates to:
  /// **'Overlay effect'**
  String get overlayEffect;

  /// No description provided for @overlayEffectHelper.
  ///
  /// In en, this message translates to:
  /// **'Adds a visual effect over the text'**
  String get overlayEffectHelper;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration (seconds)'**
  String get duration;

  /// No description provided for @durationDefault.
  ///
  /// In en, this message translates to:
  /// **'5'**
  String get durationDefault;

  /// No description provided for @durationHelper.
  ///
  /// In en, this message translates to:
  /// **'Notification display duration (default: 5s)'**
  String get durationHelper;

  /// No description provided for @durationMinimum.
  ///
  /// In en, this message translates to:
  /// **'Duration must be at least 1 second'**
  String get durationMinimum;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @notificationSent.
  ///
  /// In en, this message translates to:
  /// **'Notification sent successfully!'**
  String get notificationSent;

  /// No description provided for @appCreated.
  ///
  /// In en, this message translates to:
  /// **'App \"{name}\" created successfully!'**
  String appCreated(String name);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @awtrixIp.
  ///
  /// In en, this message translates to:
  /// **'AWTRIX IP Address'**
  String get awtrixIp;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo Mode'**
  String get demoMode;

  /// No description provided for @demoModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Test without a real AWTRIX device'**
  String get demoModeDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter an address'**
  String get pleaseEnterAddress;

  /// No description provided for @invalidIpAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid IP address or hostname'**
  String get invalidIpAddress;

  /// No description provided for @deviceDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Device Discovery'**
  String get deviceDiscovery;

  /// No description provided for @discoverDevices.
  ///
  /// In en, this message translates to:
  /// **'Discover Devices'**
  String get discoverDevices;

  /// No description provided for @discoveringDevices.
  ///
  /// In en, this message translates to:
  /// **'Discovering devices on your network...'**
  String get discoveringDevices;

  /// No description provided for @devicesFound.
  ///
  /// In en, this message translates to:
  /// **'{count} device(s) found'**
  String devicesFound(int count);

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No devices found. Make sure your AWTRIX is connected to the same network.'**
  String get noDevicesFound;

  /// No description provided for @selectDevice.
  ///
  /// In en, this message translates to:
  /// **'Select a device'**
  String get selectDevice;

  /// No description provided for @manualEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manualEntry;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter IP address manually'**
  String get enterManually;

  /// No description provided for @confirmedAwtrix.
  ///
  /// In en, this message translates to:
  /// **'Confirmed AWTRIX device'**
  String get confirmedAwtrix;

  /// No description provided for @possibleDevice.
  ///
  /// In en, this message translates to:
  /// **'Possible device'**
  String get possibleDevice;

  /// No description provided for @stopDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Stop Discovery'**
  String get stopDiscovery;

  /// No description provided for @refreshDevices.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshDevices;

  /// No description provided for @validatingDevice.
  ///
  /// In en, this message translates to:
  /// **'Validating device...'**
  String get validatingDevice;

  /// No description provided for @deviceValidated.
  ///
  /// In en, this message translates to:
  /// **'Device validated successfully'**
  String get deviceValidated;

  /// No description provided for @deviceValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to device'**
  String get deviceValidationFailed;

  /// No description provided for @notAnAwtrixDevice.
  ///
  /// In en, this message translates to:
  /// **'Not an AWTRIX device'**
  String get notAnAwtrixDevice;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @demoModeActive.
  ///
  /// In en, this message translates to:
  /// **'Demo mode active'**
  String get demoModeActive;

  /// No description provided for @apiCallsSimulated.
  ///
  /// In en, this message translates to:
  /// **'API calls are simulated'**
  String get apiCallsSimulated;

  /// No description provided for @previousApp.
  ///
  /// In en, this message translates to:
  /// **'Previous app'**
  String get previousApp;

  /// No description provided for @nextApp.
  ///
  /// In en, this message translates to:
  /// **'Next app'**
  String get nextApp;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @generalTab.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalTab;

  /// No description provided for @messagesTab.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesTab;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @pleaseEnterText.
  ///
  /// In en, this message translates to:
  /// **'Please enter text'**
  String get pleaseEnterText;

  /// No description provided for @pleaseEnterAppName.
  ///
  /// In en, this message translates to:
  /// **'Please enter an app name'**
  String get pleaseEnterAppName;

  /// No description provided for @pleaseEnterDuration.
  ///
  /// In en, this message translates to:
  /// **'Please enter a duration'**
  String get pleaseEnterDuration;

  /// No description provided for @iconDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Icon {iconId} downloaded and uploaded!'**
  String iconDownloaded(int iconId);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @iconsFromLaMetric.
  ///
  /// In en, this message translates to:
  /// **'Icons are from LaMetric'**
  String get iconsFromLaMetric;

  /// No description provided for @visitLaMetricIcons.
  ///
  /// In en, this message translates to:
  /// **'Visit https://developer.lametric.com/icons to browse all available icons and find their ID.'**
  String get visitLaMetricIcons;

  /// No description provided for @popularIcons.
  ///
  /// In en, this message translates to:
  /// **'Popular icons:'**
  String get popularIcons;

  /// No description provided for @heart.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get heart;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @moon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get moon;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @cross.
  ///
  /// In en, this message translates to:
  /// **'Cross'**
  String get cross;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @bell.
  ///
  /// In en, this message translates to:
  /// **'Bell'**
  String get bell;

  /// No description provided for @star.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get star;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @bulb.
  ///
  /// In en, this message translates to:
  /// **'Bulb'**
  String get bulb;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @pleaseEnterValidIconId.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid icon ID'**
  String get pleaseEnterValidIconId;

  /// No description provided for @downloadingIcon.
  ///
  /// In en, this message translates to:
  /// **'Downloading icon...'**
  String get downloadingIcon;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
