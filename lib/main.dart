import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/main_navigation_screen.dart';
import 'services/locale_service.dart';

void main() {
  runApp(const AwtrixApp());
}

class AwtrixApp extends StatefulWidget {
  const AwtrixApp({super.key});

  @override
  State<AwtrixApp> createState() => _AwtrixAppState();

  static _AwtrixAppState? _of(BuildContext context) {
    return context.findAncestorStateOfType<_AwtrixAppState>();
  }

  static LocaleService? localeServiceOf(BuildContext context) {
    return _of(context)?._localeService;
  }
}

class _AwtrixAppState extends State<AwtrixApp> {
  final LocaleService _localeService = LocaleService();

  @override
  void initState() {
    super.initState();
    _localeService.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    _localeService.removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    setState(() {});
  }

  LocaleService get localeService => _localeService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWTRIX Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      locale: _localeService.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      home: const MainNavigationScreen(),
    );
  }
}
