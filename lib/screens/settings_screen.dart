import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/app_settings_service.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  final AppSettings currentSettings;

  const SettingsScreen({super.key, required this.currentSettings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();
  late bool _demoMode;
  final _settingsService = AppSettingsService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _ipController.text = widget.currentSettings.awtrixIp;
    _demoMode = widget.currentSettings.demoMode;
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final newSettings = AppSettings(
        awtrixIp: _ipController.text.trim(),
        demoMode: _demoMode,
      );

      await _settingsService.saveSettings(newSettings);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsSaved),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(newSettings);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = AwtrixApp.localeServiceOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Section Language
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.language,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: localeService?.locale?.languageCode ?? 'en',
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.language),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(l10n.english),
                        ),
                        DropdownMenuItem(value: 'fr', child: Text(l10n.french)),
                      ],
                      onChanged: (value) {
                        if (value != null && localeService != null) {
                          localeService.setLocale(Locale(value));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section Mode Démo
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.demoMode,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(l10n.demoMode),
                      subtitle: Text(
                        l10n.demoModeDescription,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                      value: _demoMode,
                      activeTrackColor: Colors.orange,
                      onChanged: (value) {
                        setState(() => _demoMode = value);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section Configuration AWTRIX
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AWTRIX',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: l10n.awtrixIp,
                        hintText: 'http://192.168.1.100 or http://awtrix.local',
                        prefixIcon: const Icon(Icons.link),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabled: !_demoMode,
                      ),
                      validator: (value) {
                        if (_demoMode) return null;

                        if (value == null || value.trim().isEmpty) {
                          return l10n.pleaseEnterAddress;
                        }

                        final trimmed = value.trim();
                        if (!trimmed.startsWith('http://') &&
                            !trimmed.startsWith('https://')) {
                          return l10n.addressMustStartWith;
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Bouton Enregistrer
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveSettings,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(l10n.save),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
