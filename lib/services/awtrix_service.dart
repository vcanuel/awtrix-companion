import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/awtrix_settings.dart';
import '../models/screen_data.dart';

class AwtrixService {
  final String baseUrl;
  final bool demoMode;
  static const String _demoSettingsKey = 'demo_awtrix_settings';
  static const Duration _timeout = Duration(seconds: 5);

  AwtrixService({required this.baseUrl, this.demoMode = false}) {
    developer.log(
      'AwtrixService initialized - baseUrl: $baseUrl, demoMode: $demoMode',
      name: 'AwtrixService',
    );
  }

  // Récupère les données de l'écran (pixels RGB888 en JSON)
  Future<ScreenData> getScreen() async {
    developer.log('getScreen() called', name: 'AwtrixService');

    if (demoMode) {
      developer.log('Returning demo screen data', name: 'AwtrixService');
      return _getDemoScreen();
    }

    try {
      final url = '$baseUrl/api/screen';
      developer.log('Fetching screen from: $url', name: 'AwtrixService');

      final response = await http.get(Uri.parse(url)).timeout(_timeout);

      developer.log(
        'Screen response: ${response.statusCode}',
        name: 'AwtrixService',
      );

      if (response.statusCode == 200) {
        final body = response.body;
        developer.log(
          'Screen data received: ${body.length} chars',
          name: 'AwtrixService',
        );

        // Parse JSON array of RGB888 values
        final List<dynamic> rgbValues = jsonDecode(body);

        return ScreenData.fromRgb888List(rgbValues.cast<int>());
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      debugPrint('🔌 [AwtrixService] SocketException: $e');
      developer.log('SocketException: $e', name: 'AwtrixService', error: e);
      throw Exception(
        'Impossible de se connecter à l\'appareil. Vérifiez l\'adresse IP et que l\'appareil est allumé.',
      );
    } on TimeoutException catch (e) {
      debugPrint('⏱️ [AwtrixService] TimeoutException: $e');
      developer.log('TimeoutException: $e', name: 'AwtrixService', error: e);
      throw Exception('Délai d\'attente dépassé. L\'appareil ne répond pas.');
    } catch (e) {
      debugPrint('❌ [AwtrixService] Unknown error: $e');
      developer.log('Unknown error: $e', name: 'AwtrixService', error: e);
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Récupère les paramètres de l'appareil
  Future<AwtrixSettings> getSettings() async {
    debugPrint('⚙️ [AwtrixService] getSettings() called');
    developer.log('getSettings() called', name: 'AwtrixService');

    if (demoMode) {
      debugPrint('🎭 [AwtrixService] Returning demo settings');
      developer.log('Returning demo settings', name: 'AwtrixService');
      return _loadDemoSettings();
    }

    try {
      // Récupérer les settings et les stats en parallèle
      final settingsUrl = '$baseUrl/api/settings';
      final statsUrl = '$baseUrl/api/stats';
      developer.log('Fetching settings and stats', name: 'AwtrixService');

      final responses = await Future.wait([
        http.get(Uri.parse(settingsUrl)).timeout(_timeout),
        http.get(Uri.parse(statsUrl)).timeout(_timeout),
      ]);

      final settingsResponse = responses[0];
      final statsResponse = responses[1];

      if (settingsResponse.statusCode == 200) {
        final settingsJson = jsonDecode(settingsResponse.body);

        // Ajouter les stats au JSON des settings si disponibles
        if (statsResponse.statusCode == 200) {
          final statsJson = jsonDecode(statsResponse.body);
          // Fusionner le niveau de batterie depuis stats
          if (statsJson.containsKey('bat')) {
            settingsJson['BAT'] = statsJson['bat'];
          }
          developer.log('Stats merged successfully', name: 'AwtrixService');
        }

        developer.log('Settings received successfully', name: 'AwtrixService');
        return AwtrixSettings.fromJson(settingsJson);
      } else {
        throw Exception('Erreur serveur: ${settingsResponse.statusCode}');
      }
    } on SocketException catch (e) {
      developer.log('SocketException: $e', name: 'AwtrixService', error: e);
      throw Exception(
        'Impossible de se connecter à l\'appareil. Vérifiez l\'adresse IP et que l\'appareil est allumé.',
      );
    } on TimeoutException catch (e) {
      developer.log('TimeoutException: $e', name: 'AwtrixService', error: e);
      throw Exception('Délai d\'attente dépassé. L\'appareil ne répond pas.');
    } catch (e) {
      developer.log('Unknown error: $e', name: 'AwtrixService', error: e);
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Met à jour les paramètres de l'appareil
  Future<void> updateSettings(AwtrixSettings settings) async {
    if (demoMode) {
      // En mode démo, sauvegarder dans SharedPreferences
      await _saveDemoSettings(settings);
      await Future.delayed(const Duration(milliseconds: 200));
      return;
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/settings'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(settings.toJson()),
          )
          .timeout(_timeout);
      if (response.statusCode != 200) {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
        'Impossible de se connecter à l\'appareil. Vérifiez l\'adresse IP et que l\'appareil est allumé.',
      );
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé. L\'appareil ne répond pas.');
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Redémarre l'appareil AWTRIX
  Future<void> reboot() async {
    if (demoMode) {
      // En mode démo, on simule un délai
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/reboot'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(_timeout);
      if (response.statusCode != 200) {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
        'Impossible de se connecter à l\'appareil. Vérifiez l\'adresse IP et que l\'appareil est allumé.',
      );
    } on TimeoutException {
      throw Exception('Délai d\'attente dépassé. L\'appareil ne répond pas.');
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  // Génère un écran de démo avec du texte animé
  ScreenData _getDemoScreen() {
    final pixels = <int>[];

    // Génère un pattern de texte "AWTRIX" style pixelisé
    final pattern = _generateDemoPattern();

    // Couleur orange vif en RGB565 (RGB: 255, 100, 0)
    const orangeRgb565 = 0xFD00; // Orange vif
    // Couleur cyan en RGB565 pour les deux points (RGB: 0, 200, 255)
    const cyanRgb565 = 0x065F; // Cyan

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 32; x++) {
        int rgb565;
        if (pattern[y][x]) {
          // Vérifier si c'est les deux points du milieu (colonne 12)
          if (x == 12 && (y == 2 || y == 4)) {
            rgb565 = cyanRgb565; // Cyan pour les deux points
          } else {
            rgb565 = orangeRgb565; // Orange pour les chiffres
          }
        } else {
          // Pixel inactif - noir
          rgb565 = 0x0000;
        }

        // Convertir RGB565 en bytes (big endian)
        pixels.add((rgb565 >> 8) & 0xFF);
        pixels.add(rgb565 & 0xFF);
      }
    }

    return ScreenData.fromRgb565List(pixels);
  }

  // Génère un pattern de texte pour le mode démo
  List<List<bool>> _generateDemoPattern() {
    // Pattern 8x32 pour afficher du texte pixelisé
    final pattern = List.generate(8, (_) => List.filled(32, false));

    // Obtenir l'heure actuelle
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    // Extraire les chiffres
    final hourTens = hour ~/ 10;
    final hourOnes = hour % 10;
    final minuteTens = minute ~/ 10;
    final minuteOnes = minute % 10;

    // Dessiner l'heure actuelle (HH:MM)
    _drawDigit(pattern, 0, 1, hourTens); // Dizaine heure
    _drawDigit(pattern, 6, 1, hourOnes); // Unité heure
    _drawColon(pattern, 12, 1); // :
    _drawDigit(pattern, 15, 1, minuteTens); // Dizaine minute
    _drawDigit(pattern, 21, 1, minuteOnes); // Unité minute

    return pattern;
  }

  void _drawDigit(List<List<bool>> pattern, int startX, int startY, int digit) {
    // Patterns 5x5 pour les chiffres 0-9
    final digits = {
      0: [
        [true, true, true],
        [true, false, true],
        [true, false, true],
        [true, false, true],
        [true, true, true],
      ],
      1: [
        [false, true, false],
        [true, true, false],
        [false, true, false],
        [false, true, false],
        [true, true, true],
      ],
      2: [
        [true, true, true],
        [false, false, true],
        [true, true, true],
        [true, false, false],
        [true, true, true],
      ],
      3: [
        [true, true, true],
        [false, false, true],
        [true, true, true],
        [false, false, true],
        [true, true, true],
      ],
      4: [
        [true, false, true],
        [true, false, true],
        [true, true, true],
        [false, false, true],
        [false, false, true],
      ],
      5: [
        [true, true, true],
        [true, false, false],
        [true, true, true],
        [false, false, true],
        [true, true, true],
      ],
      6: [
        [true, true, true],
        [true, false, false],
        [true, true, true],
        [true, false, true],
        [true, true, true],
      ],
      7: [
        [true, true, true],
        [false, false, true],
        [false, false, true],
        [false, false, true],
        [false, false, true],
      ],
      8: [
        [true, true, true],
        [true, false, true],
        [true, true, true],
        [true, false, true],
        [true, true, true],
      ],
      9: [
        [true, true, true],
        [true, false, true],
        [true, true, true],
        [false, false, true],
        [true, true, true],
      ],
    };

    final digitPattern = digits[digit] ?? digits[0]!;
    for (int y = 0; y < digitPattern.length && startY + y < 8; y++) {
      for (int x = 0; x < digitPattern[y].length && startX + x < 32; x++) {
        pattern[startY + y][startX + x] = digitPattern[y][x];
      }
    }
  }

  void _drawColon(List<List<bool>> pattern, int startX, int startY) {
    if (startY + 1 < 8 && startX < 32) pattern[startY + 1][startX] = true;
    if (startY + 3 < 8 && startX < 32) pattern[startY + 3][startX] = true;
  }

  // Charge les paramètres de démo depuis SharedPreferences
  Future<AwtrixSettings> _loadDemoSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_demoSettingsKey);

    if (settingsJson != null) {
      try {
        final json = jsonDecode(settingsJson);
        return AwtrixSettings.fromJson(json);
      } catch (e) {
        // Si erreur de décodage, retourner les paramètres par défaut
        return _getDefaultDemoSettings();
      }
    }

    // Première utilisation, retourner les paramètres par défaut
    return _getDefaultDemoSettings();
  }

  // Sauvegarde les paramètres de démo dans SharedPreferences
  Future<void> _saveDemoSettings(AwtrixSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(settings.toJson());
    await prefs.setString(_demoSettingsKey, json);
  }

  // Paramètres de démo par défaut
  AwtrixSettings _getDefaultDemoSettings() {
    final random = Random();
    return AwtrixSettings(
      matrixEnabled: true,
      textColor: const Color(0xFFFFFFFF),
      brightness: 90,
      autoTransition: true,
      transitionSpeed: 400,
      transitionEffect: 'Random',
      uppercaseLetters: true,
      blockButtons: false,
      autoBrightness: false,
      appTime: 7,
      batteryLevel: 65 + random.nextInt(30), // Batterie entre 65% et 95%
    );
  }
}
