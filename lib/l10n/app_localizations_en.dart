// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AWTRIX Companion';

  @override
  String get general => 'General';

  @override
  String get matrix => 'Matrix';

  @override
  String get autoBrightness => 'Auto Brightness';

  @override
  String get brightness => 'Brightness';

  @override
  String get autoTransition => 'Auto Transition';

  @override
  String get matrixOff => 'Matrix off';

  @override
  String get actions => 'Actions';

  @override
  String get reboot => 'Reboot';

  @override
  String get rebootDevice => 'Reboot device';

  @override
  String get rebootConfirmTitle => 'Reboot';

  @override
  String get rebootConfirmMessage =>
      'Are you sure you want to reboot the device?';

  @override
  String get cancel => 'Cancel';

  @override
  String get rebooting => 'Rebooting...';

  @override
  String get turnOn => 'Turn on';

  @override
  String get turnOff => 'Turn off';

  @override
  String get turnOnMatrix => 'Turn on LED matrix';

  @override
  String get turnOffMatrix => 'Turn off LED matrix';

  @override
  String get turnOffConfirmTitle => 'Turn off';

  @override
  String get turnOffConfirmMessage =>
      'Are you sure you want to turn off the LED matrix?';

  @override
  String get matrixTurnedOn => 'LED matrix turned on';

  @override
  String get matrixTurnedOff => 'LED matrix turned off';

  @override
  String get sleepMode => 'Sleep mode';

  @override
  String get sleepModeDescription => 'Put device in deep sleep';

  @override
  String get sleepDuration => 'Sleep duration in seconds:';

  @override
  String get seconds => 'Seconds';

  @override
  String get oneHour => '1 hour = 3600s';

  @override
  String get activate => 'Activate';

  @override
  String sleepActivated(int duration) {
    return 'Sleep mode activated for ${duration}s';
  }

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get loadingError => 'Loading error';

  @override
  String get settingsUpdated => 'Settings updated';

  @override
  String get awtrixServiceUnavailable => 'AWTRIX service unavailable';

  @override
  String get message => 'Message';

  @override
  String get enterText => 'Enter your notification text';

  @override
  String get enterTextHint => 'Enter text';

  @override
  String get sendAsApp => 'Send as app';

  @override
  String get sendAsAppDescription =>
      'Create a custom app instead of a temporary notification';

  @override
  String get appName => 'App name';

  @override
  String get appNameDefault => 'companion';

  @override
  String get appNameHelper => 'Unique identifier for the custom app';

  @override
  String get icon => 'Icon';

  @override
  String get iconId => 'Icon (ID)';

  @override
  String get chooseIcon => 'Choose an icon';

  @override
  String get textColor => 'Text color';

  @override
  String get textEffects => 'Text effects';

  @override
  String get blink => 'Blink (ms)';

  @override
  String get blinkHelper => 'Blink interval in milliseconds';

  @override
  String get fade => 'Fade (ms)';

  @override
  String get fadeHelper => 'Fade interval in milliseconds';

  @override
  String get rainbowEffect => 'Rainbow effect';

  @override
  String get rainbowEffectDescription =>
      'Scrolls each letter through the RGB spectrum';

  @override
  String get backgroundColor => 'Background color';

  @override
  String get backgroundColorDescription => 'Set a custom background color';

  @override
  String get chooseBackgroundColor => 'Choose background color';

  @override
  String get overlayEffect => 'Overlay effect';

  @override
  String get overlayEffectHelper => 'Adds a visual effect over the text';

  @override
  String get none => 'None';

  @override
  String get duration => 'Duration (seconds)';

  @override
  String get durationDefault => '5';

  @override
  String get durationHelper => 'Notification display duration (default: 5s)';

  @override
  String get durationMinimum => 'Duration must be at least 1 second';

  @override
  String get send => 'Send';

  @override
  String get notificationSent => 'Notification sent successfully!';

  @override
  String appCreated(String name) {
    return 'App \"$name\" created successfully!';
  }

  @override
  String get settings => 'Settings';

  @override
  String get awtrixIp => 'AWTRIX IP Address';

  @override
  String get save => 'Save';

  @override
  String get demoMode => 'Demo Mode';

  @override
  String get demoModeDescription => 'Test without a real AWTRIX device';

  @override
  String get language => 'Language';

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get pleaseEnterAddress => 'Please enter an address';

  @override
  String get addressMustStartWith =>
      'Address must start with http:// or https://';

  @override
  String get connected => 'Connected';

  @override
  String get demoModeActive => 'Demo mode active';

  @override
  String get apiCallsSimulated => 'API calls are simulated';

  @override
  String get previousApp => 'Previous app';

  @override
  String get nextApp => 'Next app';

  @override
  String get loading => 'Loading...';

  @override
  String get generalTab => 'General';

  @override
  String get messagesTab => 'Messages';

  @override
  String get notifications => 'Notifications';

  @override
  String get pleaseEnterText => 'Please enter text';

  @override
  String get pleaseEnterAppName => 'Please enter an app name';

  @override
  String get pleaseEnterDuration => 'Please enter a duration';

  @override
  String iconDownloaded(int iconId) {
    return 'Icon $iconId downloaded and uploaded!';
  }

  @override
  String get close => 'Close';

  @override
  String get iconsFromLaMetric => 'Icons are from LaMetric';

  @override
  String get visitLaMetricIcons =>
      'Visit https://developer.lametric.com/icons to browse all available icons and find their ID.';

  @override
  String get popularIcons => 'Popular icons:';

  @override
  String get heart => 'Heart';

  @override
  String get email => 'Email';

  @override
  String get sun => 'Sun';

  @override
  String get moon => 'Moon';

  @override
  String get check => 'Check';

  @override
  String get cross => 'Cross';

  @override
  String get alert => 'Alert';

  @override
  String get bell => 'Bell';

  @override
  String get star => 'Star';

  @override
  String get home => 'Home';

  @override
  String get bulb => 'Bulb';

  @override
  String get music => 'Music';

  @override
  String get download => 'Download';

  @override
  String get select => 'Select';

  @override
  String get pleaseEnterValidIconId => 'Please enter a valid icon ID';

  @override
  String get downloadingIcon => 'Downloading icon...';
}
