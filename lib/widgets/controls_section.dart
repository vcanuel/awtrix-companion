import 'package:flutter/material.dart';
import '../models/awtrix_settings.dart';
import 'switch_control.dart';
import 'color_control.dart';
import 'slider_control.dart';

class ControlsSection extends StatelessWidget {
  final AwtrixSettings settings;
  final Function(AwtrixSettings) onSettingsUpdate;
  final VoidCallback onColorPickerTap;

  const ControlsSection({
    super.key,
    required this.settings,
    required this.onSettingsUpdate,
    required this.onColorPickerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'General',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Matrix On/Off
          SwitchControl(
            label: 'Matrix',
            value: settings.matrixEnabled,
            onChanged: (value) {
              final newSettings = settings.copyWith(
                matrixEnabled: value,
              );
              onSettingsUpdate(newSettings);
            },
          ),

          const Divider(height: 32),

          // Text Color
          ColorControl(
            label: 'Textcolor',
            color: settings.textColor,
            onTap: onColorPickerTap,
          ),

          const Divider(height: 32),

          // Brightness
          SliderControl(
            label: 'Brightness',
            value: settings.brightness.toDouble(),
            min: 0,
            max: 255,
            onChanged: (value) {
              final newSettings = settings.copyWith(
                brightness: value.toInt(),
              );
              onSettingsUpdate(newSettings);
            },
          ),

          const Divider(height: 32),

          // Auto Transition
          SwitchControl(
            label: 'Auto Transition',
            value: settings.autoTransition,
            onChanged: (value) {
              final newSettings = settings.copyWith(
                autoTransition: value,
              );
              onSettingsUpdate(newSettings);
            },
          ),
        ],
      ),
    );
  }
}
