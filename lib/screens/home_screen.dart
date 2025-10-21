import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../models/app_settings.dart';
import '../models/awtrix_settings.dart';
import '../models/screen_data.dart';
import '../services/app_settings_service.dart';
import '../services/awtrix_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_selector.dart';
import '../widgets/battery_indicator.dart';
import '../widgets/controls_section.dart';
import '../widgets/led_screen_display.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AwtrixService? _awtrixService;
  AppSettings? _appSettings;
  AwtrixSettings? _settings;
  ScreenData? _screenData;
  bool _isLoading = true;
  bool _isConnected = false;
  final _appSettingsService = AppSettingsService();
  Timer? _refreshTimer;
  AwtrixApp _selectedApp = AwtrixApp.time;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Charger les paramètres de l'application
    final settings = await _appSettingsService.loadSettings();

    setState(() {
      _appSettings = settings;
      // Initialiser le service AWTRIX avec les paramètres chargés
      _awtrixService = AwtrixService(
        baseUrl: settings.awtrixIp,
        demoMode: settings.demoMode,
      );
    });

    _loadData();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_awtrixService == null) return;

    debugPrint('🔄 [HomeScreen] Loading data from AWTRIX...');
    developer.log('Loading data from AWTRIX', name: 'HomeScreen');
    setState(() => _isLoading = true);

    try {
      debugPrint('📡 [HomeScreen] Fetching settings and screen data...');
      developer.log('Fetching settings and screen...', name: 'HomeScreen');
      final settings = await _awtrixService!.getSettings();
      final screen = await _awtrixService!.getScreen();

      debugPrint('✅ [HomeScreen] Data loaded successfully');
      developer.log('Data loaded successfully', name: 'HomeScreen');
      setState(() {
        _settings = settings;
        _screenData = screen;
        _isLoading = false;
        _isConnected = true;
      });
    } catch (e) {
      debugPrint('❌ [HomeScreen] Error loading data: $e');
      developer.log('Error loading data: $e', name: 'HomeScreen', error: e);
      setState(() {
        _isLoading = false;
        _isConnected = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  Future<void> _updateSettings(
    AwtrixSettings newSettings, {
    bool showSnackBar = true,
  }) async {
    if (_awtrixService == null) return;

    try {
      await _awtrixService!.updateSettings(newSettings);
      setState(() => _settings = newSettings);

      // En mode démo, ne pas afficher le SnackBar car les changements sont instantanés
      // En mode réel, afficher seulement si demandé
      if (mounted && showSnackBar && !(_awtrixService?.demoMode ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paramètres mis à jour'),
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  Future<void> _openSettings() async {
    if (_appSettings == null) return;

    final result = await Navigator.push<AppSettings>(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(currentSettings: _appSettings!),
      ),
    );

    // Si les paramètres ont été modifiés, réinitialiser l'application
    if (result != null) {
      setState(() {
        _appSettings = result;
        _awtrixService = AwtrixService(
          baseUrl: _appSettings!.awtrixIp,
          demoMode: _appSettings!.demoMode,
        );
      });
      _loadData();
      _startAutoRefresh();
    }
  }

  void _showColorPicker() {
    if (_settings == null) return;

    Color selectedColor = _settings!.textColor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Couleur du texte'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              // Seulement mettre à jour la couleur locale, pas encore sur l'appareil
              selectedColor = color;
              setState(() {
                _settings = _settings!.copyWith(textColor: color);
              });
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Appliquer les changements à la fermeture
              final newSettings = _settings!.copyWith(textColor: selectedColor);
              _updateSettings(newSettings);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRebootConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redémarrer AWTRIX'),
        content: const Text(
          'Êtes-vous sûr de vouloir redémarrer l\'appareil AWTRIX ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
            child: const Text('Redémarrer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _rebootDevice();
    }
  }

  Future<void> _rebootDevice() async {
    if (_awtrixService == null) return;

    try {
      await _awtrixService!.reboot();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Redémarrage en cours...'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AWTRIX Companion'),
        backgroundColor: Colors.grey.shade900,
        actions: [
          // Indicateur de batterie
          if (_settings?.batteryLevel != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: BatteryIndicator(batteryLevel: _settings!.batteryLevel),
              ),
            ),
          // Bouton reboot
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _showRebootConfirmation,
            tooltip: 'Redémarrer',
          ),
          // Indicateur de statut de connexion
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isConnected ? Colors.green : Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: _isConnected
                          ? Colors.green.withValues(alpha: 0.5)
                          : Colors.red.withValues(alpha: 0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(
        awtrixService: _awtrixService,
        appSettings: _appSettings,
        onSettingsTap: _openSettings,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _settings == null
          ? const Center(child: Text('Erreur de chargement'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Écran LED
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LedScreenDisplay(
                      screenData: _screenData,
                      height: 120,
                    ),
                  ),

                  // Section des contrôles
                  ControlsSection(
                    settings: _settings!,
                    onSettingsUpdate: _updateSettings,
                    onColorPickerTap: _showColorPicker,
                  ),

                  const SizedBox(height: 16),

                  // Sélecteur d'apps (carousel)
                  AppSelector(
                    selectedApp: _selectedApp,
                    onPrevious: () {
                      setState(() {
                        final currentIndex = _selectedApp.index;
                        final newIndex =
                            (currentIndex - 1) % AwtrixApp.values.length;
                        _selectedApp = AwtrixApp.values[newIndex];
                      });
                      // TODO: Implémenter le changement d'app sur l'appareil
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('App: ${_selectedApp.label}'),
                          duration: const Duration(milliseconds: 800),
                        ),
                      );
                    },
                    onNext: () {
                      setState(() {
                        final currentIndex = _selectedApp.index;
                        final newIndex =
                            (currentIndex + 1) % AwtrixApp.values.length;
                        _selectedApp = AwtrixApp.values[newIndex];
                      });
                      // TODO: Implémenter le changement d'app sur l'appareil
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('App: ${_selectedApp.label}'),
                          duration: const Duration(milliseconds: 800),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
