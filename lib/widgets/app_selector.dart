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
  final AwtrixApp selectedApp;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const AppSelector({
    super.key,
    required this.selectedApp,
    required this.onPrevious,
    required this.onNext,
  });

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
                Icon(selectedApp.icon, size: 40, color: Colors.deepOrange),
                const SizedBox(height: 8),
                Text(
                  selectedApp.label,
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
