import 'package:flutter/material.dart';
import '../models/app_settings.dart';
import '../services/awtrix_service.dart';

class AppDrawer extends StatelessWidget {
  final AwtrixService? awtrixService;
  final AppSettings? appSettings;
  final VoidCallback onSettingsTap;

  const AppDrawer({
    super.key,
    required this.awtrixService,
    required this.appSettings,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade900,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepOrange.shade700),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.grid_on, size: 48, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'AWTRIX Companion',
                  style: TextStyle(
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
            title: const Text(
              'Paramètres',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context); // Fermer le drawer
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
                awtrixService!.demoMode ? 'Mode Démo' : 'Connecté',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                awtrixService!.demoMode
                    ? 'Les appels API sont simulés'
                    : appSettings!.awtrixIp,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
