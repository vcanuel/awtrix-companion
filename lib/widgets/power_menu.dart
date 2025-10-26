import 'package:flutter/material.dart';
import '../services/awtrix_service.dart';

class PowerMenu {
  static Future<void> show(
    BuildContext context,
    AwtrixService? awtrixService,
    bool isMatrixOn,
  ) async {
    if (awtrixService == null) return;

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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.orange),
              title: const Text('Redémarrer'),
              subtitle: const Text('Redémarre l\'appareil AWTRIX'),
              onTap: () {
                Navigator.pop(context);
                _executeReboot(context, awtrixService);
              },
            ),
            // Afficher "Allumer" ou "Éteindre" selon l'état
            ListTile(
              leading: Icon(
                Icons.power_settings_new,
                color: isMatrixOn ? Colors.red : Colors.green,
              ),
              title: Text(isMatrixOn ? 'Éteindre' : 'Allumer'),
              subtitle: Text(
                isMatrixOn ? 'Éteint la matrice LED' : 'Allume la matrice LED',
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
              title: const Text('Mode veille'),
              subtitle: const Text('Met l\'appareil en veille profonde'),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redémarrer'),
        content: const Text(
          'Êtes-vous sûr de vouloir redémarrer l\'appareil ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Redémarrer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await awtrixService.reboot();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Redémarrage en cours...'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
        }
      }
    }
  }

  static Future<void> _executePowerOn(
    BuildContext context,
    AwtrixService awtrixService,
  ) async {
    try {
      await awtrixService.setPower(true);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Matrice LED allumée'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  static Future<void> _executePowerOff(
    BuildContext context,
    AwtrixService awtrixService,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Éteindre'),
        content: const Text(
          'Êtes-vous sûr de vouloir éteindre la matrice LED ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Éteindre'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await awtrixService.setPower(false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Matrice LED éteinte'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
        }
      }
    }
  }

  static Future<void> _showSleepDialog(
    BuildContext context,
    AwtrixService awtrixService,
  ) async {
    final controller = TextEditingController(text: '3600');

    final duration = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mode veille'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Durée de veille en secondes :'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Secondes',
                hintText: '3600',
                helperText: '1 heure = 3600s',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.of(context).pop(value);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.blue),
            child: const Text('Activer'),
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
              content: Text('Mode veille activé pour ${duration}s'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
        }
      }
    }
  }
}
