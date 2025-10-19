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
  final int? batteryLevel; // Pourcentage de batterie (0-100)

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
  });

  factory AwtrixSettings.fromJson(Map<String, dynamic> json) {
    return AwtrixSettings(
      matrixEnabled: json['MATP'] ?? json['MAT'] ?? true, // MATP pour on/off, MAT en fallback
      textColor: Color(json['TCOLOR'] ?? 0xFFFFFFFF),
      brightness: json['BRI'] ?? 90,
      autoTransition: json['ATRANS'] ?? true,
      transitionSpeed: json['TSPEED'] ?? 400,
      transitionEffect: json['TEFF'] ?? 'Random',
      uppercaseLetters: json['UPPERCASE'] ?? true,
      blockButtons: json['BLOCKKEYS'] ?? false,
      autoBrightness: json['ABRI'] ?? false,
      appTime: json['ATIME'] ?? 7,
      batteryLevel: json['BAT'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'MATP': matrixEnabled, // Utiliser MATP pour activer/désactiver la matrice
      'TCOLOR': textColor.toARGB32(),
      'BRI': brightness,
      'ATRANS': autoTransition,
      'TSPEED': transitionSpeed,
      'TEFF': transitionEffect,
      'UPPERCASE': uppercaseLetters,
      'BLOCKKEYS': blockButtons,
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
    );
  }
}
