import 'package:flutter/material.dart';
import '../models/awtrix_settings.dart';
import '../l10n/app_localizations.dart';
import 'switch_control.dart';
import 'slider_control.dart';

class ControlsSection extends StatelessWidget {
  final AwtrixSettings settings;
  final Function(AwtrixSettings) onSettingsUpdate;

  const ControlsSection({
    super.key,
    required this.settings,
    required this.onSettingsUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          Text(
            l10n.general,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Matrix On/Off
          SwitchControl(
            label: l10n.matrix,
            value: settings.matrixEnabled,
            onChanged: (value) {
              final newSettings = settings.copyWith(matrixEnabled: value);
              onSettingsUpdate(newSettings);
            },
          ),

          const Divider(height: 32),

          // Auto Brightness
          SwitchControl(
            label: l10n.autoBrightness,
            value: settings.autoBrightness,
            onChanged: (value) {
              final newSettings = settings.copyWith(autoBrightness: value);
              onSettingsUpdate(newSettings);
            },
          ),

          const Divider(height: 32),

          // Brightness (disabled if auto brightness is enabled)
          Opacity(
            opacity: settings.autoBrightness ? 0.5 : 1.0,
            child: IgnorePointer(
              ignoring: settings.autoBrightness,
              child: SliderControl(
                label: l10n.brightness,
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
            ),
          ),

          const Divider(height: 32),

          // Auto Transition
          SwitchControl(
            label: l10n.autoTransition,
            value: settings.autoTransition,
            onChanged: (value) {
              final newSettings = settings.copyWith(autoTransition: value);
              onSettingsUpdate(newSettings);
            },
          ),
        ],
      ),
    );
  }
}
