import 'package:flutter/material.dart';

enum AwtrixApp {
  time('Time', Icons.access_time),
  date('Date', Icons.calendar_today),
  temperature('Temperature', Icons.thermostat),
  humidity('Humidity', Icons.water_drop),
  battery('Battery', Icons.battery_charging_full);

  final String label;
  final IconData icon;

  const AwtrixApp(this.label, this.icon);
}

class AppSelector extends StatelessWidget {
  final String? currentAppName;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const AppSelector({
    super.key,
    this.currentAppName,
    required this.onPrevious,
    required this.onNext,
  });

  IconData _getIconForApp(String? appName) {
    if (appName == null) return Icons.apps;

    switch (appName.toLowerCase()) {
      case 'time':
        return Icons.access_time;
      case 'date':
        return Icons.calendar_today;
      case 'temperature':
        return Icons.thermostat;
      case 'humidity':
        return Icons.water_drop;
      case 'battery':
        return Icons.battery_charging_full;
      default:
        return Icons.apps;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton précédent
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 32),
            onPressed: onPrevious,
            color: Colors.deepOrange,
            tooltip: 'App précédente',
          ),

          // App actuelle
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconForApp(currentAppName),
                  size: 40,
                  color: Colors.deepOrange,
                ),
                const SizedBox(height: 8),
                Text(
                  currentAppName ?? 'Chargement...',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Bouton suivant
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 32),
            onPressed: onNext,
            color: Colors.deepOrange,
            tooltip: 'App suivante',
          ),
        ],
      ),
    );
  }
}
