import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../models/awtrix_settings.dart';
import '../services/awtrix_service.dart';
import '../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  final AwtrixService? awtrixService;
  final AppSettings? appSettings;
  final AwtrixSettings? awtrixSettings;
  final VoidCallback onSettingsTap;

  const AppDrawer({
    super.key,
    required this.awtrixService,
    required this.appSettings,
    this.awtrixSettings,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: Colors.grey.shade900,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepOrange.shade700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.grid_on, size: 48, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: Text(
              l10n.settings,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              onSettingsTap();
            },
          ),
          const Divider(color: Colors.grey),
          if (awtrixService != null && appSettings != null)
            ListTile(
              leading: Icon(
                awtrixService!.demoMode ? Icons.play_arrow : Icons.link,
                color: Colors.white,
              ),
              title: Text(
                awtrixService!.demoMode ? l10n.demoModeActive : l10n.connected,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!awtrixService!.demoMode) ...[
                    // Show device name if available
                    if (awtrixSettings?.uid != null)
                      Text(
                        awtrixSettings!.uid!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    // Show IP without http://
                    Text(
                      appSettings!.awtrixIp
                          .replaceFirst('http://', '')
                          .replaceFirst('https://', ''),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ] else
                    Text(
                      l10n.apiCallsSimulated,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
