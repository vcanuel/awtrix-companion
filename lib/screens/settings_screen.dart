import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/app_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final AppSettings currentSettings;

  const SettingsScreen({
    super.key,
    required this.currentSettings,
  });

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paramètres enregistrés'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(newSettings);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Section Mode Démo
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mode de fonctionnement',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Mode Démo'),
                      subtitle: Text(
                        _demoMode
                            ? 'Les appels API sont simulés'
                            : 'Connexion à l\'appareil AWTRIX',
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
                      'Configuration AWTRIX',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: 'Adresse IP ou URL',
                        hintText: 'http://192.168.1.100 ou http://awtrix.local',
                        prefixIcon: const Icon(Icons.link),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        helperText: _demoMode
                            ? 'Non utilisé en mode démo'
                            : 'Adresse de votre appareil AWTRIX',
                        enabled: !_demoMode,
                      ),
                      validator: (value) {
                        if (_demoMode) return null;

                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez entrer une adresse';
                        }

                        final trimmed = value.trim();
                        if (!trimmed.startsWith('http://') &&
                            !trimmed.startsWith('https://')) {
                          return 'L\'adresse doit commencer par http:// ou https://';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (!_demoMode)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue.shade700,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade300,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Exemple: http://192.168.1.100 ou http://awtrix.local',
                                style: TextStyle(
                                  color: Colors.blue.shade300,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
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
              label: Text(_isSaving ? 'Enregistrement...' : 'Enregistrer'),
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
