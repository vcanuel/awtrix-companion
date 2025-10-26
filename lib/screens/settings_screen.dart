import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/app_settings_service.dart';
import '../services/device_discovery_service.dart';
import '../models/discovered_device.dart';
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
  final _discoveryService = DeviceDiscoveryService();
  bool _isSaving = false;
  bool _showDiscovery = false;
  List<DiscoveredDevice> _discoveredDevices = [];

  @override
  void initState() {
    super.initState();
    // Remove http:// from stored IP for display
    String displayIp = widget.currentSettings.awtrixIp;
    displayIp = displayIp
        .replaceFirst('http://', '')
        .replaceFirst('https://', '');
    _ipController.text = displayIp;
    _demoMode = widget.currentSettings.demoMode;

    // Listen to device discovery updates
    _discoveryService.devicesStream.listen((devices) {
      if (mounted) {
        setState(() {
          _discoveredDevices = devices;
        });
      }
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _discoveryService.dispose();
    super.dispose();
  }

  Future<void> _startDiscovery() async {
    setState(() {
      _showDiscovery = true;
      _discoveredDevices = [];
    });

    await _discoveryService.startDiscovery();
  }

  Future<void> _selectDevice(DiscoveredDevice device) async {
    setState(() {
      _ipController.text = device.ip;
      _showDiscovery = false;
    });

    // Auto-save the selected device
    final newSettings = AppSettings(
      awtrixIp: 'http://${device.ip}',
      demoMode: _demoMode,
    );
    await _settingsService.saveSettings(newSettings);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${device.displayName} - ${l10n.settingsSaved}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Clean IP and add http:// if not present
      String ipAddress = _ipController.text.trim();
      ipAddress = ipAddress
          .replaceFirst('http://', '')
          .replaceFirst('https://', '');
      ipAddress = 'http://$ipAddress';

      final newSettings = AppSettings(awtrixIp: ipAddress, demoMode: _demoMode);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            // Return current settings when closing with back button
            final currentSettings = await _settingsService.loadSettings();
            if (context.mounted) {
              Navigator.of(context).pop(currentSettings);
            }
          },
        ),
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

                    // Device Discovery Button
                    if (!_demoMode && !_showDiscovery)
                      OutlinedButton.icon(
                        onPressed: _startDiscovery,
                        icon: const Icon(Icons.search),
                        label: Text(l10n.discoverDevices),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),

                    // Discovery in progress
                    if (_showDiscovery && _discoveryService.isScanning) ...[
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.grey.shade800,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 16),
                              Text(
                                l10n.discoveringDevices,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Discovered devices list
                    if (_showDiscovery && _discoveredDevices.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.grey.shade800,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.devicesFound(
                                      _discoveredDevices.length,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.refresh),
                                        onPressed: _startDiscovery,
                                        tooltip: l10n.refreshDevices,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            _showDiscovery = false;
                                          });
                                        },
                                        tooltip: l10n.close,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _discoveredDevices.length,
                                itemBuilder: (context, index) {
                                  final device = _discoveredDevices[index];
                                  return ListTile(
                                    leading: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    title: Text(device.displayName),
                                    subtitle: Text(
                                      device.ip,
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 11,
                                      ),
                                    ),
                                    onTap: () => _selectDevice(device),
                                    trailing: const Icon(Icons.arrow_forward),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // No devices found message
                    if (_showDiscovery &&
                        !_discoveryService.isScanning &&
                        _discoveredDevices.isEmpty) ...[
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.grey.shade800,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.wifi_off,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noDevicesFound,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade300),
                              ),
                              const SizedBox(height: 16),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _showDiscovery = false;
                                  });
                                },
                                icon: const Icon(Icons.close),
                                label: Text(l10n.close),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Manual IP entry
                    TextFormField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: l10n.awtrixIp,
                        hintText: '192.168.1.100 or awtrix.local',
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

                        // Remove http:// or https:// if user entered it
                        final cleanValue = trimmed
                            .replaceFirst('http://', '')
                            .replaceFirst('https://', '');

                        // Validate IP address format (IPv4) or hostname
                        final ipRegex = RegExp(
                          r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$',
                        );
                        final hostnameRegex = RegExp(
                          r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?$',
                        );

                        if (!ipRegex.hasMatch(cleanValue) &&
                            !hostnameRegex.hasMatch(cleanValue)) {
                          return l10n.invalidIpAddress;
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
