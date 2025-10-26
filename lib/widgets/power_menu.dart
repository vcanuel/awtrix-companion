import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/awtrix_service.dart';

class PowerMenu {
  static Future<void> show(
    BuildContext context,
    AwtrixService? awtrixService,
    bool isMatrixOn,
  ) async {
    if (awtrixService == null) return;

    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.actions,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.orange),
              title: Text(l10n.reboot),
              subtitle: Text(l10n.rebootDevice),
              onTap: () {
                Navigator.pop(context);
                _executeReboot(context, awtrixService);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.power_settings_new,
                color: isMatrixOn ? Colors.red : Colors.green,
              ),
              title: Text(isMatrixOn ? l10n.turnOff : l10n.turnOn),
              subtitle: Text(
                isMatrixOn ? l10n.turnOffMatrix : l10n.turnOnMatrix,
              ),
              onTap: () {
                Navigator.pop(context);
                if (isMatrixOn) {
                  _executePowerOff(context, awtrixService);
                } else {
                  _executePowerOn(context, awtrixService);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.bedtime, color: Colors.blue),
              title: Text(l10n.sleepMode),
              subtitle: Text(l10n.sleepModeDescription),
              onTap: () {
                Navigator.pop(context);
                _showSleepDialog(context, awtrixService);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static Future<void> _executeReboot(
    BuildContext context,
    AwtrixService awtrixService,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.rebootConfirmTitle),
        content: Text(l10n.rebootConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: Text(l10n.reboot),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await awtrixService.reboot();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.rebooting),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
        }
      }
    }
  }

  static Future<void> _executePowerOn(
    BuildContext context,
    AwtrixService awtrixService,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      await awtrixService.setPower(true);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.matrixTurnedOn),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
      }
    }
  }

  static Future<void> _executePowerOff(
    BuildContext context,
    AwtrixService awtrixService,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.turnOffConfirmTitle),
        content: Text(l10n.turnOffConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.turnOff),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await awtrixService.setPower(false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.matrixTurnedOff),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
        }
      }
    }
  }

  static Future<void> _showSleepDialog(
    BuildContext context,
    AwtrixService awtrixService,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: '3600');

    final duration = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sleepMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.sleepDuration),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: l10n.seconds,
                hintText: '3600',
                helperText: l10n.oneHour,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.of(context).pop(value);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: Text(l10n.activate),
          ),
        ],
      ),
    );

    if (duration != null) {
      try {
        await awtrixService.sleep(duration);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.sleepActivated(duration)),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
        }
      }
    }
  }
}
