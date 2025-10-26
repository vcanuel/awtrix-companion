import 'package:flutter/material.dart';
import '../services/awtrix_service.dart';
import '../services/app_settings_service.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'custom_app_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  AwtrixService? _awtrixService;
  final _appSettingsService = AppSettingsService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Charger les paramètres de l'application
    final settings = await _appSettingsService.loadSettings();

    setState(() {
      // Initialiser le service AWTRIX avec les paramètres chargés
      _awtrixService = AwtrixService(
        baseUrl: settings.awtrixIp,
        demoMode: settings.demoMode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      const HomeScreen(),
      CustomAppScreen(awtrixService: _awtrixService),
    ];

    return Scaffold(
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
