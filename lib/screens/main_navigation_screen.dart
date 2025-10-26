import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/awtrix_settings.dart';
import '../services/awtrix_service.dart';
import '../services/app_settings_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_drawer.dart';
import '../widgets/battery_indicator.dart';
import '../widgets/power_menu.dart';
import 'home_screen.dart';
import 'custom_app_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  AwtrixService? _awtrixService;
  AppSettings? _appSettings;
  AwtrixSettings? _homeScreenSettings;
  bool _isConnected = false;
  final _appSettingsService = AppSettingsService();

  void _updateHomeScreenState(AwtrixSettings? settings, bool isConnected) {
    setState(() {
      _homeScreenSettings = settings;
      _isConnected = isConnected;
    });
  }

  void _showPowerMenu() {
    PowerMenu.show(
      context,
      _awtrixService,
      _homeScreenSettings?.matrixEnabled ?? true,
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load application settings
    final settings = await _appSettingsService.loadSettings();

    setState(() {
      _appSettings = settings;
      // Initialize AWTRIX service with loaded settings
      _awtrixService = AwtrixService(
        baseUrl: settings.awtrixIp,
        demoMode: settings.demoMode,
      );
    });
  }

  Future<void> _openSettings() async {
    if (_appSettings == null) return;

    final result = await Navigator.push<AppSettings>(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsScreen(currentSettings: _appSettings!),
      ),
    );

    // If settings were modified, reinitialize the application
    if (result != null) {
      setState(() {
        _appSettings = result;
        _awtrixService = AwtrixService(
          baseUrl: result.awtrixIp,
          demoMode: result.demoMode,
        );
      });
    }
  }

  Widget _buildConnectionIndicator() {
    return Padding(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      HomeScreen(onStateChanged: _updateHomeScreenState),
      CustomAppScreen(awtrixService: _awtrixService),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? l10n.appTitle : l10n.messagesTab),
        backgroundColor: Colors.grey.shade900,
        actions: [
          // Battery indicator (only on Home tab)
          if (_currentIndex == 0 && _homeScreenSettings?.batteryLevel != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: BatteryIndicator(
                  batteryLevel: _homeScreenSettings!.batteryLevel,
                ),
              ),
            ),
          // Power menu button (on all tabs)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showPowerMenu,
            tooltip: l10n.actions,
          ),
          // Connection status indicator (on all tabs)
          _buildConnectionIndicator(),
        ],
      ),
      drawer: AppDrawer(
        awtrixService: _awtrixService,
        appSettings: _appSettings,
        onSettingsTap: _openSettings,
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.grey.shade900,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.generalTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.message),
            label: l10n.messagesTab,
          ),
        ],
      ),
    );
  }
}
