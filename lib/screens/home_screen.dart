import 'dart:async';
import 'package:flutter/material.dart';
import '../models/awtrix_settings.dart';
import '../models/screen_data.dart';
import '../services/app_settings_service.dart';
import '../services/awtrix_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_selector.dart';
import '../widgets/controls_section.dart';
import '../widgets/led_screen_display.dart';

class HomeScreen extends StatefulWidget {
  final Function(AwtrixSettings?, bool)? onStateChanged;

  const HomeScreen({super.key, this.onStateChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AwtrixService? _awtrixService;
  AwtrixSettings? _settings;
  ScreenData? _screenData;
  bool _isLoading = true;
  bool _isConnected = false;
  final _appSettingsService = AppSettingsService();
  Timer? _refreshTimer;

  void _notifyStateChanged() {
    widget.onStateChanged?.call(_settings, _isConnected);
  }

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
    // Load application settings
    final settings = await _appSettingsService.loadSettings();

    setState(() {
      // Initialize AWTRIX service with loaded settings
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
    // Augmenter l'intervalle à 5 secondes pour un refresh plus fluide
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadData(
        showLoading: false,
      ); // Ne pas afficher le loading lors du refresh auto
    });
  }

  Future<void> _loadData({bool showLoading = true}) async {
    if (_awtrixService == null) return;

    // Show loading only on first load
    if (showLoading) {
      setState(() => _isLoading = true);
    }

    try {
      final settings = await _awtrixService!.getSettings();
      final screen = await _awtrixService!.getScreen();

      if (mounted) {
        setState(() {
          _settings = settings;
          _screenData = screen;
          _isLoading = false;
          _isConnected = true;
        });
        _notifyStateChanged();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isConnected = false;
        });
        _notifyStateChanged();
        // Show error only if not a silent refresh
        if (showLoading) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
        }
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsUpdated),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
      }
    }
  }

  Future<void> _switchToPreviousApp() async {
    if (_awtrixService == null) return;
    final messenger = ScaffoldMessenger.of(context);

    try {
      // Mettre à jour immédiatement l'affichage avec un placeholder
      setState(() {
        _settings = _settings?.copyWith(currentApp: '...');
      });

      await _awtrixService!.previousApp();
      // Attendre que la transition soit terminée avant de rafraîchir
      await Future.delayed(const Duration(milliseconds: 500));
      // Rafraîchir pour obtenir l'app courante
      await _loadData(showLoading: false);
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('App: ${_settings?.currentApp ?? "..."}'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.error(e.toString()))),
        );
      }
    }
  }

  Future<void> _switchToNextApp() async {
    if (_awtrixService == null) return;
    final messenger = ScaffoldMessenger.of(context);

    try {
      // Mettre à jour immédiatement l'affichage avec un placeholder
      setState(() {
        _settings = _settings?.copyWith(currentApp: '...');
      });

      await _awtrixService!.nextApp();
      // Attendre que la transition soit terminée avant de rafraîchir
      await Future.delayed(const Duration(milliseconds: 500));
      // Rafraîchir pour obtenir l'app courante
      await _loadData(showLoading: false);
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('App: ${_settings?.currentApp ?? "..."}'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.error(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _settings == null
          ? Center(child: Text(AppLocalizations.of(context)!.loadingError))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // LED Screen
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LedScreenDisplay(
                      screenData: _screenData,
                      height: 120,
                      isMatrixOn: _settings?.matrixEnabled ?? true,
                    ),
                  ),

                  // Controls section
                  ControlsSection(
                    settings: _settings!,
                    onSettingsUpdate: _updateSettings,
                  ),

                  const SizedBox(height: 16),

                  // App selector (carousel)
                  AppSelector(
                    currentAppName: _settings?.currentApp,
                    onPrevious: _switchToPreviousApp,
                    onNext: _switchToNextApp,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
