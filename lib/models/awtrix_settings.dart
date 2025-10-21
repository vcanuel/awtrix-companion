import 'dart:ui';

class AwtrixSettings {
  final bool matrixEnabled;
  final Color textColor;
  final int brightness;
  final bool autoTransition;
  final int transitionSpeed;
  final String transitionEffect;
  final bool uppercaseLetters;
  final bool blockButtons;
  final bool autoBrightness;
  final int appTime;
  final int? batteryLevel; // Pourcentage de batterie (0-100) ou null si branché
  final String? currentApp; // App actuellement affichée sur AWTRIX

  AwtrixSettings({
    required this.matrixEnabled,
    required this.textColor,
    required this.brightness,
    required this.autoTransition,
    this.transitionSpeed = 400,
    this.transitionEffect = 'Random',
    this.uppercaseLetters = true,
    this.blockButtons = false,
    this.autoBrightness = false,
    this.appTime = 7,
    this.batteryLevel,
    this.currentApp,
  });

  factory AwtrixSettings.fromJson(Map<String, dynamic> json) {
    // Helper pour convertir n'importe quel type en String
    String parseString(dynamic value, String defaultValue) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    }

    // Helper pour convertir n'importe quel type en int
    int parseInt(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      if (value is double) return value.toInt();
      if (value is bool) return defaultValue; // Ignore les booléens
      return defaultValue;
    }

    // Helper pour convertir le niveau de batterie (peut être int ou bool)
    int? parseBatteryLevel(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is bool) return null; // true/false ne sont pas des pourcentages
      if (value is String) return int.tryParse(value);
      return null;
    }

    // Helper pour convertir n'importe quel type en bool
    bool parseBool(dynamic value, bool defaultValue) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is int) return value != 0;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return defaultValue;
    }

    return AwtrixSettings(
      matrixEnabled: parseBool(
        json['MATP'] ?? json['MAT'],
        true,
      ), // MATP ou MAT en fallback
      textColor: Color(
        parseInt(json['TCOL'] ?? json['TCOLOR'], 0xFFFFFFFF),
      ), // TCOL dans l'API réelle
      brightness: parseInt(json['BRI'], 90),
      autoTransition: parseBool(json['ATRANS'], true),
      transitionSpeed: parseInt(json['TSPEED'], 400),
      transitionEffect: parseString(
        json['TEFF'],
        'Random',
      ), // TEFF peut être un int ou String
      uppercaseLetters: parseBool(
        json['UPPERCASE'] ?? json['TMODE'],
        true,
      ), // TMODE en fallback
      blockButtons: parseBool(json['BLOCKKEYS'] ?? json['BLOCKN'], false),
      autoBrightness: parseBool(json['ABRI'], false),
      appTime: parseInt(json['ATIME'], 7),
      batteryLevel: parseBatteryLevel(json['BAT']),
      currentApp: json['CURRENT_APP'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'MATP': matrixEnabled, // Utiliser MATP pour activer/désactiver la matrice
      'TCOL': textColor.toARGB32(), // TCOL dans l'API réelle (int 32-bit)
      'BRI': brightness,
      'ATRANS': autoTransition,
      'TSPEED': transitionSpeed,
      'TEFF': transitionEffect,
      'TMODE': uppercaseLetters ? 1 : 0, // TMODE dans l'API réelle
      'BLOCKN': blockButtons,
      'ABRI': autoBrightness,
      'ATIME': appTime,
    };
    // Ne pas inclure batteryLevel dans le JSON car c'est en lecture seule
    return json;
  }

  AwtrixSettings copyWith({
    bool? matrixEnabled,
    Color? textColor,
    int? brightness,
    bool? autoTransition,
    int? transitionSpeed,
    String? transitionEffect,
    bool? uppercaseLetters,
    bool? blockButtons,
    bool? autoBrightness,
    int? appTime,
    int? batteryLevel,
    String? currentApp,
  }) {
    return AwtrixSettings(
      matrixEnabled: matrixEnabled ?? this.matrixEnabled,
      textColor: textColor ?? this.textColor,
      brightness: brightness ?? this.brightness,
      autoTransition: autoTransition ?? this.autoTransition,
      transitionSpeed: transitionSpeed ?? this.transitionSpeed,
      transitionEffect: transitionEffect ?? this.transitionEffect,
      uppercaseLetters: uppercaseLetters ?? this.uppercaseLetters,
      blockButtons: blockButtons ?? this.blockButtons,
      autoBrightness: autoBrightness ?? this.autoBrightness,
      appTime: appTime ?? this.appTime,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      currentApp: currentApp ?? this.currentApp,
    );
  }
}
