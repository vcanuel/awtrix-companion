import 'package:flutter/material.dart';

class BatteryIndicator extends StatelessWidget {
  final int? batteryLevel;

  const BatteryIndicator({super.key, required this.batteryLevel});

  IconData _getBatteryIcon() {
    // null = branché sur secteur (pas sur batterie)
    if (batteryLevel == null) return Icons.power;
    if (batteryLevel! >= 90) return Icons.battery_full;
    if (batteryLevel! >= 60) return Icons.battery_5_bar;
    if (batteryLevel! >= 40) return Icons.battery_4_bar;
    if (batteryLevel! >= 20) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  Color _getBatteryColor() {
    // null = branché sur secteur (vert car alimenté)
    if (batteryLevel == null) return Colors.green;
    if (batteryLevel! >= 40) return Colors.green;
    if (batteryLevel! >= 20) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade700, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getBatteryIcon(), size: 20, color: _getBatteryColor()),
          const SizedBox(width: 6),
          Text(
            batteryLevel != null ? '$batteryLevel%' : 'AC',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getBatteryColor(),
            ),
          ),
        ],
      ),
    );
  }
}
